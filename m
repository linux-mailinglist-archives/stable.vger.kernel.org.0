Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19B5BFDC3
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiIUMXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiIUMXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:23:36 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7961A97EC6;
        Wed, 21 Sep 2022 05:23:32 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1280590722dso8809378fac.1;
        Wed, 21 Sep 2022 05:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=3aJj791SFi8MBmk/3DDeNGs8qJFxgSOFtNXhCuwyFlE=;
        b=gZm6pXwMq2/JC/UTzDilnXvNNyRSckcot0YJ/NTaLbwgqLHVdBCLiaVvIB0NkJ3bmZ
         1nk1BYSkGZOBASjKxyjllVNk8cab+Hm+DELpIecZjGPDzX2v6JwuUZjXls2mHcirK/+e
         GjHbLX+FHDyaNPWfCqF087+Pmtdly7g0V902It5/Dx8SAE/K1+IM5JFG6ucNTT+cOkQf
         m8u3mwFCbWbPL8pqwWcIkjsxR8riTQ9TH/I8mBcIyfB08ZYi+DoeoHcsYYgHLNBEQyFC
         KgihHc1TC+jck3iRBGiWUKBctERjn3cr1gNKfLL4FDlLcx9b8NBlZbFIrHHHViZYVUGz
         VmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3aJj791SFi8MBmk/3DDeNGs8qJFxgSOFtNXhCuwyFlE=;
        b=dhJkOts+5k8Wmkk4KRUUXuZG7kvFYSYZdW/pxM8N9fwHiKWVFEaPocwtjchslb/fNe
         ZZAO4kt1vt6ShQw+GBZi5OknO0QEa+RcVcZWSx39knPDwwXg4+f0JGm3dCTWtS9toSg1
         fi574GFxSgF6181Vjdpk8lrToTN8MQdSaYy7mBJwp+YH72O87PCP0q9/iSb753SL8Wv9
         G6jDWZkv8YZen26m3kjXFf/xPzSLchymxLH8etEn9Nm77fzgqjoea9Iv9UT7TLANae3r
         o9v0TAbgORbEPy7FKfQUMrnwuSo+cDGywzGVAKT0Nz8qXQZWF8c4Mbk3CNBY3VULWXPB
         G1QA==
X-Gm-Message-State: ACrzQf3NaDW5cjC2ZhUHmKSKtUKU/WAtFiJU7DQ/+fND3AmbqXMVdAdP
        9O10kfacZ3BBjNagu01Zz09YfR4N+kZQDNT9F1Y=
X-Google-Smtp-Source: AMsMyM5ErvoOnIfJMUuBO4BbuAQd4iK1fvd9USzMtEX4sLhb80TdK3rfkL+JCPZ9lgL8+EHwcHMCghXo3GDIFPNl3xA=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr4900564oao.112.1663763011355; Wed, 21
 Sep 2022 05:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
 <20220921044419.epojssm3g4j3qkup@riteshh-domain>
In-Reply-To: <20220921044419.epojssm3g4j3qkup@riteshh-domain>
From:   hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>
Date:   Wed, 21 Sep 2022 13:22:55 +0100
Message-ID: <CACX6voCxHGd46ehrsys+3sVrA2Stq++O2ofh7E6f4MTN59Z2NQ@mail.gmail.com>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for sharing that unfortunately this patch has been merged to
kernel 5.7 and I am still seeing that regression with later versions
that include that patch.

Hazem.

On Wed, 21 Sept 2022 at 05:44, Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> On 22/09/19 04:18PM, hazem ahmed mohamed wrote:
> > Hey Team,
> >
> >
> >
> > I am sending this e-mail to report a performance regression that=E2=80=
=99s
> > caused by commit 244adf6426(ext4: make dioread_nolock the default) , I
> > am listing the performance regression symptoms below & our analysis
> > for the reported regression.
> >
>
> Although you did mention you already tested on the latest kernel too and =
there
> too you saw a similar performance regression.
> But no harm in also double checking if you have this patch [1].
> This does fixes a similar problem AFAIU.
>
>
> [1]: https://lore.kernel.org/linux-ext4/20200520133119.1383-1-jack@suse.c=
z/
>
> -ritesh
