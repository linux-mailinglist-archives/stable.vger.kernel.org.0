Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A586627954
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 10:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiKNJqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 04:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiKNJqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 04:46:04 -0500
X-Greylist: delayed 491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 01:46:00 PST
Received: from relay.mgdcloud.pe (relay.mgdcloud.pe [201.234.116.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EE91E3DB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 01:45:59 -0800 (PST)
Received: from relay.mgdcloud.pe (localhost.localdomain [127.0.0.1])
        by relay.mgdcloud.pe (Proxmox) with ESMTP id E0ACA22995F;
        Mon, 14 Nov 2022 04:37:04 -0500 (-05)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cgracephoto.com;
         h=cc:content-description:content-transfer-encoding:content-type
        :content-type:date:from:from:message-id:mime-version:reply-to
        :reply-to:subject:subject:to:to; s=Relay; bh=POmmLhbs6/14Mhmcbsw
        HpX0H+MIlo+W0e6cG8XDkBG8=; b=UL0+52PvcLeg+GgMhZlhjQnvqfipV9jikYw
        +x+ATtlikX/Xy2Hn3rjq6ZTxNd4ii+PJsj+PozhFKLl2z0vLmV5Tk5p/OIAWiVsS
        f16M0zXGbYtCzWhL+us3pOt0bi/eYUfoyspuWzUMj0/V8RBhUEPQ1WHqjkrat8P0
        QZG35+RF9vWhFyC3R22jMxn6OmVQcmEPx0a/3C/kP4sw18vsPa40Nui1D/sk1zdx
        8pHFL2b1JpljN3QNtBxvgSWmLcOKHuMTECAmNNDCU5k6CvSmSYFJTbFgfZCmUP1r
        s6YF4TxC1d7YZlP2LSxXslklRMrvckBpra3o9pcBzNtlGrD9zYw==
Received: from portal.mgd.pe (portal.mgd.pe [107.1.2.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by relay.mgdcloud.pe (Proxmox) with ESMTPS id C7FB422995D;
        Mon, 14 Nov 2022 04:37:04 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id AA9E220187D80;
        Mon, 14 Nov 2022 04:37:04 -0500 (-05)
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id B3Axzj7LknIK; Mon, 14 Nov 2022 04:37:04 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id 5C74A20187D83;
        Mon, 14 Nov 2022 04:37:04 -0500 (-05)
X-Virus-Scanned: amavisd-new at mgd.pe
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tG66YxzIkEpy; Mon, 14 Nov 2022 04:37:04 -0500 (-05)
Received: from [103.125.190.179] (unknown [103.125.190.179])
        by portal.mgd.pe (Postfix) with ESMTPSA id BEADF20187D80;
        Mon, 14 Nov 2022 04:36:57 -0500 (-05)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Strategic plan
To:     Recipients <cindy@cgracephoto.com>
From:   "Mr.IgorS. Lvovich" <cindy@cgracephoto.com>
Date:   Mon, 14 Nov 2022 01:36:52 -0800
Reply-To: richad.tang@yahoo.com.hk
Message-Id: <20221114093657.BEADF20187D80@portal.mgd.pe>
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,HK_NAME_MR_MRS,RCVD_IN_SBL,
        SPF_FAIL,SPF_HELO_PASS,TO_EQ_FM_DOM_SPF_FAIL,TO_EQ_FM_SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello
I will like to use the liberty of this medium to inform you as a consultant=
,that my principal is interested in investing his bond/funds as a silent bu=
siness partner in your company.Taking into proper
consideration the Return on Investment(ROI) based on a ten (10) year strate=
gic plan.
I shall give you details when you reply.

Regards,

