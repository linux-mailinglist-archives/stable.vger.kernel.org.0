Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C25A6149
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfICGWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:22:24 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42465 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfICGWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:22:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id C3DC216D5;
        Tue,  3 Sep 2019 02:22:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 02:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=/xUD1wLmlpwJ5edK6tPldfDA3Ye
        FCK8ecZmnsFsCvOc=; b=jIa9Ctjn7vppxVEyKvYa1j7vpoyCifALHPMV9llsRHF
        dKl9H8QPOpwU+Jffublx8gYhKbJeVqjAoIysLvi8NOTXlTLuyGIj7hQVOni/zu4H
        LyAheB107TdhTXuHd+pCGhofXRARQ5ImT8MhVXnQ6hbkgdklf6mynZGHCHlWPtyN
        gHBc9vIA+5rmMRgPn5WZxznaBOVU5GhQwaYZY8G+AAIzeDmPp4jMLF7ZjMJvmpI7
        37uB21QlQC2bXzk3OgmuyWTky1DsEN23ZN2kEVvUXcPGpve3Od3Jv8VP51c+bmuF
        OtR1ddhb+oCkLfb32nsDcIVLdMggPTx0ra18Jk/nl6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/xUD1w
        LmlpwJ5edK6tPldfDA3YeFCK8ecZmnsFsCvOc=; b=PLkUsrI398X/WvogxsAD0k
        f/3DBXXZhn3U7+WnMM5Rs7KU8d0sZLOW3D+0i+zmnhDOewsYNUQLLwF7G/NIOUY+
        pRzd4pmhYzxEdjSw4VuYNR5YOxDqxegHjBbWzZp76w584wJSE+8768rY+sqwPHEM
        vOr3KJ71YXUVYAlUmOXBmy2vVt/Jdd+rN8zoYELt0Uq4rerDTGmJjrxuHRQMAdCT
        tBQsGekkAyG2uOeIOrqF9MUxJmL0h5A6GXK+MnAHAnzxCbqw1j3PWHrr3cXgyN4A
        pLUa1ec/VVKcjBNAStCG5+cr5EBPccp4B3a6Mr1vA1ZkeClHL4cBgbqB/Qmhd2HQ
        ==
X-ME-Sender: <xms:nQZuXc84uyenr4nhBaypfB3UtEVzbO30kA9GXZvN9pWK7ELtEvyDBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejuddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nQZuXfWCElGXem0P1CFg1EcuzWE4aWcgqX7pigTzLuqUmrMcE4ioVw>
    <xmx:nQZuXWHLyh8mPMkdWIvN65UrfSvPVNhldrN26A7fK-_MO1brGucmwQ>
    <xmx:nQZuXRtD9EsLShxRge0W1gF32td00ZXho-4bDHBCSiHtShlz8Do5Cw>
    <xmx:ngZuXXr8odWrDiDoBZ7yGpvklvEX4ha1bkyHP4ApmzhxEBSM3C7Pag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 478CCD6006A;
        Tue,  3 Sep 2019 02:22:21 -0400 (EDT)
Date:   Tue, 3 Sep 2019 08:22:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
Message-ID: <20190903062219.GB16647@kroah.com>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001816.427611357@stormcage.eag.rdlabs.hpecorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903001816.427611357@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 07:18:21PM -0500, Mike Travis wrote:
> Decode the hubless UVsystab passed from BIOS to the kernel saving
> pertinent info in a similar manner that hubbed UVsystabs are decoded.
> 
> Signed-off-by: Mike Travis <mike.travis@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Same thing goes for all of the patches in this series...
