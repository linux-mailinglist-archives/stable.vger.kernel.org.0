Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B422CDD66
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501914AbgLCSYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:24:45 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:42691 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436500AbgLCSYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:24:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D7B78580497;
        Thu,  3 Dec 2020 13:23:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 03 Dec 2020 13:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=QP4GaR0zm1Ub7XkhQv7Jc4kTE+P
        vBmdV/xXIkDwGDfw=; b=wT+g8Ll/pQ8FMT4zqCiKH/h9As0f4dO1bzOL/RDUgvA
        Ch3nfQYuo+pYX95KoSt7eArBrElM4qqm/YXeTHajiDT+KbbXrMJnE8UunuXZceQ6
        m0m4CTwYxoWjl0LD77aPvNrJ1vcCsNrt2hEDvVwTooJmVFZF8pRF+YdMoB7x06NI
        0XYpLkWofT3DI3dASB+GB0R/rgzjePtV7C+x2yi5HTlI19ix90bqen2VgBSunZ6i
        tyKGWQMvQyfd1gbsk7j29LU6dayu3uakkPYXENh7qqO6d2GgKxr2c7b/LZMl3qm5
        wFrHY9Re9lH3fIsKcW7HirJHDplR/rqROjhCP5mi8Ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QP4GaR
        0zm1Ub7XkhQv7Jc4kTE+PvBmdV/xXIkDwGDfw=; b=bBI4c2++tMa0ofW+kUNIBf
        Hd5X/T6hZW7N1ds+yFn2PUI3PqO+xVNSS4IFC17Z+hNr0GyloQ6+NTbKZLVpiY+J
        rgCQ0jb7patAKWnmO4MsfKM4YeR44xhMRzqSKH2H96Ji0nkjxlC8JfxVcc6O2Vt3
        txaDnKp9g7gwp739T5xWzEJO/EKdnLf2UdpOJvT1Zam5PZYmdr8LG4vRK0rVTT87
        3m6gFANslVNlfuRqhseKGEAPM1l5/IK02qWV7qZDN2PT+q6rO+IuH6R6wwQHNU3o
        2t7OSviN+RxwIfbqwVZQF8nuRnaxGz0ado41B28g5BKOhBHsw6z/s267zK/Z/nYA
        ==
X-ME-Sender: <xms:PS3JX9x2kFt4KUjjW5kZ4QVwljZ5dH6nLy4lPMc_r_fMpWL_bmFW5w>
    <xme:PS3JX9RfEmrzENRtDcRu8BpUh4mv5-rdCTu5M9DIDZTx4nA8jbrHnEpXOGoGsL8jx
    zbqsk2hy-C5yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeiiedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PS3JX3Wdu9LuHIiIUh3vBTKSZoe74V9PK-H5GuTPZk05SepySzrcGw>
    <xmx:PS3JX_iUGCy_AlDyAPRnLe-Xi7QZs6DLslBc6R-P2ituSA2FSd_HgA>
    <xmx:PS3JX_ABMn1naBiHJRY0N44GoQOisk4Vpd1B6PyfPrnH9rBNM19_Pg>
    <xmx:PS3JXz7w3J7NK4BTgOTnOSDEDXj5MLshEAyONZR0npGHxXndIRKdug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 693E0108005B;
        Thu,  3 Dec 2020 13:23:56 -0500 (EST)
Date:   Thu, 3 Dec 2020 19:25:05 +0100
From:   Greg KH <greg@kroah.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        James.Bottomley@suse.de,
        jayamohank@hdredirect-lb5-1afb6e2973825a56.elb.us-east-1.amazonaws.com,
        jejb@linux.ibm.com, jitendra.bhivare@broadcom.com,
        kernel-janitors@vger.kernel.org, ketan.mukadam@broadcom.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: revert "Fix a theoretical leak in
 beiscsi_create_eqs()"
Message-ID: <X8ktgeCVhGPw4wnW@kroah.com>
References: <54f36c62-10bf-8736-39ce-27ece097d9de@proxmox.com>
 <X8jXkt6eThjyVP1v@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8jXkt6eThjyVP1v@mwanda>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 03:18:26PM +0300, Dan Carpenter wrote:
> My patch caused kernel Oopses and delays in boot.  Revert it.
> 
> The problem was that I moved the "mem->dma = paddr;" before the call to
> be_fill_queue().  But the first thing that the be_fill_queue() function
> does is memset the whole struct to zero which overwrites the assignment.
> 
> Fixes: 38b2db564d9a ("scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()")
> Reported-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Can someone please add:
	Cc: stable <stable@vger.kernel.org>
to this so we know to pick it up quickly there?

thanks,

greg k-h
