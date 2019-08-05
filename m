Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D662D818A5
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHEL7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 07:59:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60543 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbfHEL7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 07:59:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9317821C1C;
        Mon,  5 Aug 2019 07:59:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 07:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=QAdrxyccERv3sIpHVxH7zok3MEa
        ldMyI79OJlAJ8vJs=; b=hPwmONQtyhx21Nnd7zBJqBCL3dHblOEwqDB5WiN/3gv
        Vm3DMh1DVRdH8thC0+0tSnX1vPaiIeU1RySr+zPxB+5qd0YXPa/Rt6qh5ytr6F3T
        SM808M9BP4N2jYMUQ2GWwLXbpt8Zs8fJrVDsDVZ7fXK+AAXfKS6AGbovV0R6KRxf
        sKYzGeWzDQumfV8WC9RT7IoDyBeB7fhVWdLscN3tqCDaIBascScqWGmzW4WD9WZh
        SJGHRT6GPFnBKfV/vD99oVkIXCCFdtZuz+JNThUr9MlE9sC6KQM9Uemk8hyGKK5P
        IN8IqXX/0KGOhNH2Mr6Z/ZEBdi3YgYur5674/tOUqnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QAdrxy
        ccERv3sIpHVxH7zok3MEaldMyI79OJlAJ8vJs=; b=ww51hEiQUJn9OttTtHXtFJ
        cHgDsX7/7eezGX6S6nltKIYrbNkJ+bHY0urh0PLQECmyku9g0wMC3PU4iQaLsRJD
        DMe6yjkzuvOR0BDj0dfUCR7qTfpLE+jGpZL9yenqemCpA+MnAn3h1bWePY3jxCGn
        xHT9rv91/PQDM+BKrgzl5DZH3rSN+GQ6M83szP5h426kAebfZQ4cMJAGocpgZv22
        EE9n4bIZAeBnKLyE8WQFp24I8P6sORMp9pP4g0pv+nHv1TWe6Pk9sMs2gqOJSSGh
        bWoFgFtV+ILe35HcdJE9TTcopvgVDCHAukR6FP/7JXD2wuMyNr6Qn+ulNYIuSaVg
        ==
X-ME-Sender: <xms:MBpIXS1KZy6sJtsLM2auN4-ERlLPQUCvg6FgVFNxYvJ9S8bmxnLbQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:MBpIXZX4P5d-5ohrtEpX254aZA0igW7M69qcoFoMDcUJeeerr0xpbA>
    <xmx:MBpIXV6imQCPSep2KMD25UXxtPFxnIinPIu-vmY2BuccPSPTrT-jzA>
    <xmx:MBpIXYKf8Yo9LAaFLO3ZsjzYFf4tp40Z7wibAZjtVYZ8KuncHSwjlQ>
    <xmx:MBpIXcFHfiRp_dGHBmL29pPJj5pZRNYLCbLBQzUKkyYPOQtxTtvzXQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E915C380074;
        Mon,  5 Aug 2019 07:59:43 -0400 (EDT)
Date:   Mon, 5 Aug 2019 13:59:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     stable@vger.kernel.org, sreekanth.reddy@broadcom.com,
        Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190805115938.GD8189@kroah.com>
References: <1564567129-9503-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1564567129-9503-2-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564567129-9503-2-git-send-email-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 05:58:49AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> if DMA able range contains all 64-bits set (0xFFFFFFFF-FFFFFFFF) then
> it results in a firmware fault.
> 
> e.g. SGE's start address is 0xFFFFFFFF-FFFF000 and
> data length is 0x1000 bytes. when HBA tries to DMA the data
> at 0xFFFFFFFF-FFFFFFFF location then HBA will
> fault the firmware.
> 
> Fix:
> Driver will set 63-bit DMA mask to ensure the above address
> will not be used.
> 
> Cc: <stable@vger.kernel.org> # 4.19.63
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
> Note:
> This Patch is for stable kernel 4.19.63.
> Original patch is applied to 5.3/scsi-fixes.
> commit ID:  df9a606184bfdb5ae3ca9d226184e9489f5c24f7

Found this one.  Now queued up,t hanks.

greg k-h
