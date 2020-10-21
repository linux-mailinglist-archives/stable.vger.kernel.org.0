Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB4294C4F
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 14:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411409AbgJUMOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 08:14:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43231 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406557AbgJUMOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 08:14:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ECE6F5C0189;
        Wed, 21 Oct 2020 08:14:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 21 Oct 2020 08:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=VM+EgBR+v+WlLP59rouMwdiITDN
        8ZA2X/h5wncXDUzE=; b=z5+23fjf/eym5cpoMH9KvozMspTmyN0uHBbKkHzH5Zv
        hWR9QaWn5fxAg04iJ7pdX0+bqSC2KwmScE+yRc8n54h8d9FGClKFiALHeNi4O/dX
        3UIgoNfJU7YodTFmjSfXtvOThUse0yJ2DCVGmETKPPPTGU1M7w4IKspUuGeC3oQu
        dUNuMIDO/aQIlGl71WjcBOv2SrGAz1KFXH2n8ZQDA0JIVRGwMD+LGZnM+ekJRDBU
        tbo2qMVrxFsaAJJcRNc4R7ZapFOEWKztbt0rAOA99ZV1lDXev+oamdosJgVfcbty
        KmE98vrozsUX7KmKJF2sgub3jYuCsU2Q9rUyASw6sxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VM+EgB
        R+v+WlLP59rouMwdiITDN8ZA2X/h5wncXDUzE=; b=HaS2rwrhej5u05eBm9PVET
        nzhdyZzF7V4kFL9jX0FVX2CFHGOJz5xHgg6eNpxyjM+g97OWMZRnD/JziYUnLGPm
        V4xzJWAeS7CnLKEjoItOblNky1ho0t17Nx3qDreyXiOgjgKjrTjw1ZHID1pmZthG
        f938rp9GcYaWq68hXEKfggPeK9fGVj+NQAUfyMW9kt8Tgd/YHHQgr6R5da/GJE3r
        /EAz0+hSdxbxZIH6tSl1QNkJkR4GyQRZhhmaNPNFCmIUNgoQqjPlvseYeJ9+4RoM
        1CGyt/dCyfLiWHB+/pI7+ZLpM10T2FswxpCIrTX7BL3L4qxnAF5KN7MMfpTrXWGw
        ==
X-ME-Sender: <xms:DiaQX4fQHscMgAqHVovmwFHmzSwMuzdBvKROeX6uwIVbrh_Z_0KSsg>
    <xme:DiaQX6Mv4g1EI9HdD9srCoQ40DbEQrWfswfmAkBuOtHBSnatm7dywzrxJpwDfi6U8
    lCbXNhQqZWevA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrjeehgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DiaQX5gSv1tQRZyTG9b2jbuS2069tbLwI5N0X7N4JDPUjj1Ut27pLg>
    <xmx:DiaQX9_mEvTGue3Cs6q6VyBG88BEPyuIVqHf-RQ9jX0y77mNkEmHwQ>
    <xmx:DiaQX0trUFsipLyNqEm1HGS-iUjCp0-VoEM9sBJdOrmiMK1yCXPBQQ>
    <xmx:DiaQXwIaDHkBiElYy4NupsNpxHV5n4OR1WH--KCKHXEKVKdrdHuJcg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 211533064610;
        Wed, 21 Oct 2020 08:14:06 -0400 (EDT)
Date:   Wed, 21 Oct 2020 14:14:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] nvme-pci: disable the write zeros command for Intel
 600P/P3100
Message-ID: <20201021121446.GB1150778@kroah.com>
References: <20201021120415.19722-1-jandryuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021120415.19722-1-jandryuk@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 08:04:15AM -0400, Jason Andryuk wrote:
> From: David Milburn <dmilburn@redhat.com>
> 
> [ Upstream commit ce4cc3133dc72c31bd49ddcf22d0f9eeff47a761 ]
> 
> The write zeros command does not work with 4k range.
> 
> bash-4.4# ./blkdiscard /dev/nvme0n1p2
> bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 2048" /dev/nvme0n1p2
> fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 2048) = 0
> +++ exited with 0 +++
> bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200
> 
> bash-4.4# ./blkdiscard /dev/nvme0n1p2
> bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 4096" /dev/nvme0n1p2
> fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 4096) = 0
> +++ exited with 0 +++
> bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
> 00000000  5c 61 5c b0 96 21 1b 5e  85 0c 07 32 9c 8c eb 3c  |\a\..!.^...2...<|
> 00000010  4a a2 06 ca 67 15 2d 8e  29 8d a8 a0 7e 46 8c 62  |J...g.-.)...~F.b|
> 00000020  bb 4c 6c c1 6b f5 ae a5  e4 a9 bc 93 4f 60 ff 7a  |.Ll.k.......O`.z|
> 
> Reported-by: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: David Milburn <dmilburn@redhat.com>
> Tested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [ Fix-up for 5.4 since NVME_QUIRK_NO_TEMP_THRESH_CHANGE doesn't exist ]
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> 
> ---
> Applicable to 5.4.  NVME_QUIRK_DISABLE_WRITE_ZEROES was introduced in 5.0.
> The original commit needs a fix for 5.4 because
> NVME_QUIRK_NO_TEMP_THRESH_CHANGE doesn't exist - it looks like it was
> added in 5.5.
> 
> Observed with mke2fs failures on 5.4 wih Intel 600P.

Now queued up, thanks.

greg k-h
