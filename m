Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E630F4E1D8A
	for <lists+stable@lfdr.de>; Sun, 20 Mar 2022 20:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbiCTTNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Mar 2022 15:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiCTTNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Mar 2022 15:13:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E693D51335;
        Sun, 20 Mar 2022 12:12:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p9so18123925wra.12;
        Sun, 20 Mar 2022 12:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SuadMlxSfGkGnsBDB8PuNxLZRp2FTuY3R2jg6AcqHr4=;
        b=cAWsPuY+dAwLlzkkRH6DCeUHwMA4C6NXJNsQ8IeKuaC18Vy/QUUDQLNhjmKkv3LRed
         Ohop4SUuSFLz9Z/g5CRXR5NqfboUJorDD+vd4wCHhJ4SF7wbh9KTM1dy8Pn4aXPyKfuZ
         xRbcIM6lVsVUF+oNAOvTxmQvIZAMMR7VkA3W8rdtgefsrNzaSz7xxxuiM45uaaZ91Kl/
         Gf8Qn8gMHdQpVkPMRAkzblnIRDRFFJjt+X4cI781jnt9j4NQlIUZmQ00B5vJ/dF50+DP
         1s2Ae9RqF1n27KfDzXzWXoDo6zZ2fbp+KV64gkhcrbjKpwe/6QkjeE5EjlCREc8lU1uD
         UcEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SuadMlxSfGkGnsBDB8PuNxLZRp2FTuY3R2jg6AcqHr4=;
        b=dYc5r4JYB/btMjaRxSPU76lvNKK6M+IOnT2oFLPBwPLBNC3cAYJ8yoLrWRjXLKqhn6
         qAhRhr1kkv5lxOc02K64W/CeaPLtlkjV0hMh3fWyHrfULsaHDtuoPVBUu3HWLSU0nlmv
         SX82M1T9SyJrFrQqxvTBZw9w6IkkH+orgHZPq9vtagsDRXLEWpoKgH4J7jcA5EQrpUbz
         eNs0gN5izhu4dMw7LNv+VRcVH0xexqYnDzaPurJIqQ0TQttmWQFKzQR7nPSEOMW+cTPv
         d+11I1sGdrqgQ0CrsFQUB8IkgjI2fPoQpgHrw+l6X0XxKlocDmlQnasyxGEjtLFXqgT8
         yaPw==
X-Gm-Message-State: AOAM531TICOpI5Zl9SS8n0KyJtCqc2fZYkN5mWS9UeTSK/Zpun8PEoqq
        dNdqoH1nUQ3Vt8YxoEN4Ma23hy/mHHhvKA==
X-Google-Smtp-Source: ABdhPJwmVCRh/nSo8JwY6wGhgFb66Atq+7YapGPSAxjUkBI/ZPClgC+Rhb0Fvoj3MGqb8p/vAgh61w==
X-Received: by 2002:a5d:650d:0:b0:1f0:19c:a066 with SMTP id x13-20020a5d650d000000b001f0019ca066mr15363551wru.149.1647803535394;
        Sun, 20 Mar 2022 12:12:15 -0700 (PDT)
Received: from elementary ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b001e6114938a8sm11496825wrs.56.2022.03.20.12.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 12:12:15 -0700 (PDT)
Date:   Sun, 20 Mar 2022 20:12:13 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Right touchpad button disabled on Dell 7750
Message-ID: <20220320191213.GA7905@elementary>
References: <s5htubv32s8.wl-tiwai@suse.de>
 <20220318130740.GA33535@elementary>
 <s5hlex72yno.wl-tiwai@suse.de>
 <CAO-hwJK8QMjYhQAC8tp7hLWZjSB3JMBJXgpKmFZRSEqPUn3_iw@mail.gmail.com>
 <s5hlex61hwu.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hlex61hwu.wl-tiwai@suse.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 19, 2022 at 09:10:57AM +0100, Takashi Iwai wrote:
> Indeed the first patch caused the wrong button mapping.
> Jose's revised patch was confirmed to work fine.

Thanks for confirming that the patch was tested Takashi.

I just emailed it:
https://lore.kernel.org/linux-input/20220320190602.7484-1-jose.exposito89@gmail.com/

Jose
