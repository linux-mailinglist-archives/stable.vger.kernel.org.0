Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A56BCE2F
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCPLad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCPLaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:30:11 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD01BCB92
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 04:30:08 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id t13so455434qkt.6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 04:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678966206;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HAxUmo8SjHlyM0KeER/jTCcJyi8ibes5NOjSJ2ceoi0=;
        b=S7LQgZoX3nnz6z1YLUOKeXPsAA3Gm3oWeRtdB3LRnjAMxkdsniYK5BOBJmBEVQP7Dp
         bYJmqkPgSepGYC4natydDwelkbCqjWrpFeoBV5lKr6yH0C1ShBIVO0gDCTCFBbdR7OtD
         fDL3gaAlTZcM/42dJ2REq56fF+m4j6b408uMZfAefTH2sC0wsd4Yq4YOEXt01SNyeA/E
         YSbTpYW5saUra8e29nz64CxmroU7Zj/OVvKxlOiLe0u5BHp56umxl3gvUl7Ec67XAc4s
         DIyWbU3fhJ51i97GeJnUOA+o0kxGAB19TwOTSO1B/68AedaU1hnB56fXD4MJKi45xqJy
         +v7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678966206;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HAxUmo8SjHlyM0KeER/jTCcJyi8ibes5NOjSJ2ceoi0=;
        b=22U9U21NTvtGH5MwqJNeg2eJaZfzRTm2A0CZ/o7ixqLQHJgJGDa2CEB0a5XfEVjrsQ
         ZkJwr9YrfPaHoBWW/GkZYE2tFr/7emMV3SkcqQBHRCkNxxUZoRY9BNO/9Ourmfhv3OuX
         hVNd99F7oXou9iLsm3yMms/37S/GxNQKMmWs+RC8zkCQtIiaKKT6D+BdFoHgj+MzBqNw
         oE2qfGi126uT4DZxBT5vf4dCuynW1AoQqWCR1kQlUyCvWzhM9CkroY2OLU+DIpjEFUjt
         pITizX6qXJ6GKJGwecnVB90PQLRCFPTPVat8FQMIWjHglmijUoZjgr7B6/PTwvzxs4Kw
         35SQ==
X-Gm-Message-State: AO0yUKV9ArFE9AawwBp6qYq+SG+N1ZYwc+gY8OxanfeORfz+SBW+bGZo
        /2q6m517T4p2f5lbVDNrqSslORcF8Cen5kBPEx5gLg==
X-Google-Smtp-Source: AK7set+SLMCT5ONmte4m1FEYSkJDuUke4a2eED695A3CDa8U1vBf5PgMtBIzMiYc3tp3v0EJ4O+8/1L7CNCYmT5RxbY=
X-Received: by 2002:a37:4545:0:b0:743:9ba:e4fa with SMTP id
 s66-20020a374545000000b0074309bae4famr4798757qka.11.1678966206120; Thu, 16
 Mar 2023 04:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230315181900.2107200-1-amit.pundir@linaro.org>
 <ZBINX5qbdmY5CQOD@kroah.com> <CAMi1Hd1VaEGcN6Z2v0_V4Msj+BddNLtfPggZpc2u1yKHRHueiQ@mail.gmail.com>
 <ZBLSg0BI28Bq31EU@kroah.com>
In-Reply-To: <ZBLSg0BI28Bq31EU@kroah.com>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Thu, 16 Mar 2023 16:59:29 +0530
Message-ID: <CAMi1Hd3v7sXwR5h0Zgn32vjN49OdJYQ7RH9NCO9yj9x9QTae0A@mail.gmail.com>
Subject: Re: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk
 after runtime pm"
To:     Greg KH <gregkh@linuxfoundation.org>,
        Srini Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 13:55, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 16, 2023 at 12:13:40AM +0530, Amit Pundir wrote:
> > On Wed, 15 Mar 2023 at 23:54, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Mar 15, 2023 at 11:49:00PM +0530, Amit Pundir wrote:
> > > > This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
> > > > commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.
> > > >
> > > > This patch broke RB5 (Qualcomm SM8250) devboard. The device
> > > > reboots into USB crash dump mode after following error:
> > > >
> > > >     qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
> > > >     ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
> > > >     Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
> > > >
> > > > Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > > > ---
> > > >  sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
> > > >  sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
> > > >  sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
> > > >  sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
> > > >  4 files changed, 23 insertions(+), 22 deletions(-)
> > >
> > > Is this also reverted in Linus's tree?  If not, why not?
> >
> > I couldn't reproduce this crash on Linus's tree. It was first reported
> > on android14-6.1 and then I could reproduce it on v6.1.19 as well,
> > hence this revert.
> >
> > A quick search points out that this patch is a part of a 8 patch
> > series https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
> > while only 5 of them landed on v6.1.y. May be we need the remaining
> > fixes on v6.1.y as well? I can give the remaining patches a quick shot
> > tomorrow if that helps.
>
> Yes please, we would much rather take whatever is in Linus's tree than a
> special revert as that will keep the trees in sync better.  If you can
> provide the missing git ids, I can just queue them up if you have tested
> them.
>

Cherry-picking the rest of the relevant fixes from the
https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
series didn't help.

Srini, does this patch series has a dependency on other upstream fixes
as well? With the above patch series on v6.1.y, I see the following
crash on RB5:

qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
q6asm-dai 17300000.remoteproc:glink-edge:apr:apr-service@7:dais:
Adding to iommu group 25
qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
APR/GPR dev: aprsvc:apr-service:4:8
qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
qcom-q6afe aprsvc:apr-service:4:4: cmd = 0x100f6 returned error = 0x1
qcom-q6afe aprsvc:apr-service:4:4: Unknown cmd 0x100f6
wsa881x-codec sdw:0:0217:2110:00:4: nonexclusive access to GPIO for powerdown
qcom-soundwire 3250000.soundwire-controller: Qualcomm Soundwire
controller v1.5.1 Registered
qcom_q6v5_pas 17300000.remoteproc: fatal error received:
ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, Number of bus hang
detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
remoteproc remoteproc1: crash detected in 17300000.remoteproc: type fatal error
remoteproc remoteproc1: handling crash #1 in 17300000.remoteproc
remoteproc remoteproc1: recovering 17300000.remoteproc
platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@5: Removing
from iommu group 23
platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@4: Removing
from iommu group 22
platform 17300000.remoteproc:glink-edge:fastrpc:compute-cb@3: Removing
from iommu group 21
qcom-q6afe aprsvc:apr-service:4:4: AFE set params failed -110
clk_unregister: unregistering prepared clock: LPASS_HW_DCODEC
clk_unregister: unregistering prepared clock: LPASS_HW_MACRO
platform 17300000.remoteproc:glink-edge:apr:apr-service@7:dais:
Removing from iommu group 25
remoteproc remoteproc1: stopped remote processor 17300000.remoteproc
remoteproc remoteproc1: remote processor 17300000.remoteproc is now up
qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@3:
Adding to iommu group 21
qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@4:
Adding to iommu group 22
qcom,fastrpc-cb 17300000.remoteproc:glink-edge:fastrpc:compute-cb@5:
Adding to iommu group 23
qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
APR/GPR dev: aprsvc:apr-service:4:3
qcom,apr 17300000.remoteproc:glink-edge.apr_audio_svc.-1.-1: Adding
APR/GPR dev: aprsvc:apr-service:4:4
SError Interrupt on CPU6, code 0x00000000be000411 -- SError
<RB5 reboots into crash mode here..>


Regards,
Amit Pundir

> thanks,
>
> greg k-h
