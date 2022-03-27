Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17094E87D5
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiC0NKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 09:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiC0NKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 09:10:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A432663F5;
        Sun, 27 Mar 2022 06:08:36 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m22so11636489pja.0;
        Sun, 27 Mar 2022 06:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ev+jFF4MWyLXe4KFMG0ej9Khdftaw0LvpKgprsKOSno=;
        b=Ufg/OZ4tD+eXPEBdYrrwtmVFy3ZFS2zmA6LG4zlQnU4T+aLWPJWTyNP+eU9Mkif4il
         3kcXtY86W/fklnC9uI+MDlhKhDSSCJRXW8UAkht7kEZuqTzgG2MqU9HtM+WbuAWY+37l
         L7WaNxT+GdFefNK1qfyTyj3L0t7yOm+zeUy3+GOq5K6t3mMnmLpQK0yIkpr1sK9I1PgM
         YvRcFnmZDV0+/98BQzyAqVeeeMbvKMGlfF9xh+YMNkuDbcZjVaL411XXZ60EufOXfqaA
         K3jb4fB11w9UL5qB73hoFsqsROPfeVQYcFFqBjmAQNoOBzKM/HkoGqm4rJ7OvxNp2Jxu
         pdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ev+jFF4MWyLXe4KFMG0ej9Khdftaw0LvpKgprsKOSno=;
        b=Tyg4+g+go4Ttc3v5JaHEKfFcR4ryrobPmbcM58J5rcGEngvHFxzmay2UxxpVHiA1q/
         PxPH+1ZskoC2tYBffKqUDmyANR/ICTS3d8Z8Ogce7D7BfAdpbPScBqF+t94pIentwQCS
         ykHV59avcAyyRlS7oKPi5FgT8dL8x77nlWXekTQPyAtsCE8bcL33j8+HmJpsCpyt04JB
         ecovYyeI47eMDAN7Qa4rP423SYVAFAmjgSODWDVRlwys2wzNZQsvjZ1GeuguD0dVYQ9E
         hCbkp7ssap9uE/Epp5BDnKcvN171Mo66CkVtj2WEE69Q9HeEL4JgPurnDB0FSZmBmyAa
         naww==
X-Gm-Message-State: AOAM532IvZuCGpDW7w+OG/GCE8a/+wLPePu4X57gA4dMZb4kzzthuMr3
        7bc1+veVXC0LXvaMwkm3yEM=
X-Google-Smtp-Source: ABdhPJyXtZD88gtYEGL6/ADVEXlDLeumzqSwdYxQT/171flyk3eAaXRePwNbyBz93CC4f454cba7VQ==
X-Received: by 2002:a17:90b:4c49:b0:1c7:d6c1:bb0f with SMTP id np9-20020a17090b4c4900b001c7d6c1bb0fmr17541719pjb.230.1648386516119;
        Sun, 27 Mar 2022 06:08:36 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm10967761pjv.57.2022.03.27.06.08.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 06:08:35 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jbrunet@baylibre.com
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        khilman@baylibre.com, lgirdwood@gmail.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        martin.blumenstingl@googlemail.com, narmstrong@baylibre.com,
        perex@perex.cz, stable@vger.kernel.org, tiwai@suse.com,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] soc: meson: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 21:08:01 +0800
Message-Id: <20220327130801.15631-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1jk0cf6480.fsf@starbuckisacylon.baylibre.com>
References: <1jk0cf6480.fsf@starbuckisacylon.baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022 13:03:14 +0200, Jerome Brunet <jbrunet@baylibre.com> wrote:
> On Sun 27 Mar 2022 at 16:18, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> 
> > The bug is here:
> > 	*dai_name = dai->driver->name;
> >
> > For for_each_component_dais(), just like list_for_each_entry,
> > the list iterator 'runtime' will point to a bogus position
> > containing HEAD if the list is empty or no element is found.
> > This case must be checked before any use of the iterator,
> > otherwise it will lead to a invalid memory access.
> >
> > To fix the bug, just move the assignment into loop and return
> > 0 when element is found, otherwise return -EINVAL;
> 
> Except we already checked that the id is valid and know an element will
> be be found once we enter the loop. No bug here and this patch does not
> seem necessary to me.

Yea, you should be right, it is not a bug here. id already be checked before
enter the loop:

if (id < 0 || id >= component->num_dai)
                return -EINVAL;

but if component->num_dai is not correct due to miscaculation or others reason
and the door is reopened, this patch can avoid a invalid memory access. Anyway,
it is a good choice to use the list iterator only inside the loop, as linus
suggested[1]. and we are on the way to change all these use-after-iter cases.

[1]https://lore.kernel.org/lkml/20220217184829.1991035-1-jakobkoschel@gmail.com/

--
Xiaomeng Tong
