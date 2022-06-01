Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7953AC67
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbiFASAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240470AbiFASAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 14:00:44 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCBD9CCBC;
        Wed,  1 Jun 2022 11:00:42 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so3424529wrc.1;
        Wed, 01 Jun 2022 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CoU8GVZ5QzWnprLeTKVABcCEkI0ltZArlMqYKwDo3Jk=;
        b=eiGrPPMO/FkatlkjR2iOWoIe0VCkBmffsNhWiePJUaROY4DpBokMA1QM8e3CbKZDOI
         p98M92aROj5kXxOugBb/2hyur2hIhpter+GHtvfFSdYwwOenmpLDsznSzfQhBsblstii
         UYUTjWU2a1K7MlqtaZUvn9sdMECwHXrmXR3E6WyLLKNDvmseRSW5y+3cFdYgLrUOjQrC
         GevQ3WXd6YbGgmB/fYpquaIpn/hhf7BQ4+UWXLgn0AdmMxcWSBNv8/A3mBdbI3TeFWVD
         T6CSZjEtqcq+sc+3G491IASex6sLNTcofM0m2MQiA3rkK7KDr7Ayi/TT/jZvmTVmakvM
         t4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CoU8GVZ5QzWnprLeTKVABcCEkI0ltZArlMqYKwDo3Jk=;
        b=xvwbh1xPenQrWxxu4V/9I5ToYKJfHjemznVMtITQcN24caEvVP2u4A2X3Vw0iLtohh
         UsC/XVOqIApw4rCASdHxVnQEZye0y2itzQo6dPOzGt9Vi8b8ZE6gSa7F1Gx509xom9Lv
         5U5/Wjj/eRWZiA/Cw3rn4FeYegD+6aUoETMEmCshj2yWe8cA16lrJ/qWXySbWRT746/M
         MhIwbuCh8ISRIJAFZ2y1/xLh9RtCiU5cRoxHvQ6BhRvIwXDKeVRdpL4C2yqrVyoHIrIi
         lws7Qsteq8ZB/ycDRL1yj2RSqAuPu5f5IifMIyVl2pp4cu7QtOB+LTte4P5eLJkagFBk
         jpzA==
X-Gm-Message-State: AOAM533hN5p2YbYeh/wGitap1waUl7uGJZGt3KBDL9RbpeJ4DlWQr6rC
        4/AqBT1klsbOxBBrDUuWKL4=
X-Google-Smtp-Source: ABdhPJzBsvEb5f2h37s48HV3fj6wUsJ0ac7NlXfHiaHg103/YAhIvUdHAYW2wVLlFLLz/9dmYaUl0Q==
X-Received: by 2002:a5d:5181:0:b0:20f:fc49:6b88 with SMTP id k1-20020a5d5181000000b0020ffc496b88mr512525wrv.596.1654106441043;
        Wed, 01 Jun 2022 11:00:41 -0700 (PDT)
Received: from elementary ([94.73.36.128])
        by smtp.gmail.com with ESMTPSA id t17-20020adfeb91000000b0021031c894d3sm2480739wrn.94.2022.06.01.11.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 11:00:40 -0700 (PDT)
Date:   Wed, 1 Jun 2022 20:00:37 +0200
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Message-ID: <20220601180037.GA26165@elementary>
References: <20220531092817.13894-1-bagasdotme@gmail.com>
 <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
 <YpcU7qeOtShFx8xR@debian.me>
 <053f756b-fafa-e07a-4308-0a5de8dda595@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <053f756b-fafa-e07a-4308-0a5de8dda595@infradead.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On 6/1/22 00:27, Bagas Sanjaya wrote:
> Running kernel-doc script on drivers/hid/hid-uclogic-params.c, it found
> 6 warnings for hid_dbg() wrapper functions below:
> [...]

Hi Bagas,

Thanks a lot for fixing these warnings. I compiled it and I can
confirm that the sparse warning is also fixed.

Tested-by: José Expósito <jose.exposito89@gmail.com>
