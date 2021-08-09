Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC73E44CE
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhHIL1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 07:27:09 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42769 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235195AbhHIL1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 07:27:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4959332001BB;
        Mon,  9 Aug 2021 07:26:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 09 Aug 2021 07:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tkZwoyoE1yWn1BXOHqiuJgEAkDb
        CUcvfkY6uuwIgd+Q=; b=AkN3Khoy6f5unBGJUdZctqt64AuWOWnKz//LYMJSLtD
        8MmJuCGq1KawAPsFKosQSd2BU6/7swPvrFxd+SMtze3Ivx31+mAz9UmGhl1ZeHnG
        wsfXyle6bXMTwDPGfw0lk+QuzuVBWXSDZggNsi8TFs1sSaiVwt3T7bznL9Y8szwy
        HacACvefh0k1KcKr3XsnqFF3bghD9DJtKwMGyvO/qSIXmA52cFo2/RnIKZ93VZMV
        9UnLNxQd/NDeH9qif9v+B9DzMMSO63q8crf0tLP+CQPQGTx1oCZjH17fdIIAfySK
        fPDZe8sq/aX+oVkFc1tDz1Nqt110+C4Kz111nOPDVWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tkZwoy
        oE1yWn1BXOHqiuJgEAkDbCUcvfkY6uuwIgd+Q=; b=aAePLaCXeNMmYsRHBcN6AG
        pJyfFJgfqMjKsegtns2l8/sRCqEHCWtsFYLiFk4zNEFMPTmAv1VdckVDtuhR/rqK
        9yWENjYasxKmX4thhpTu4KAtJygBuOJl905bmMm9XlQFVtqd4zcnaxvM6eQFFZDG
        Bw9OMz79nniBDukt2maplDgM3mi9UQZeBB6/MYnut97H40d5GIL2kowLps7WXV5U
        hVuufaOx5Dc01OCDDp3SP4pZ6G1QV+0TINEQYTRYUMM5hasOOsICzHWvHCSq5CgW
        Nrj0oGCLbHIox2nKPDqanpXgPsKFGKeAuTmZ+xArveuxf2gkWIn7SVVd/lcEXJdA
        ==
X-ME-Sender: <xms:9RARYQt6Q2PpoNfRaW5iNd_IGzxYsNagGPnAyk2pqoDjQ4OGNZvWyg>
    <xme:9RARYdf0ejcOZKCwae_UDEZ_y6hnNrEzYdDuWtV5OuwL4z5bmvLaxsGA2jAIWV7a9
    Pie126toRUr_w>
X-ME-Received: <xmr:9RARYbzB5zav3-v_Wf2YJP0y88SOF4DiCH88zoL8HcriqwsiFNMs0BvToSj9PiKXPGjPcqVI_SNinNlM3FRhV5nVsCHhalOG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9RARYTPR737T0pSeM_ydQ2y7qPM6qs9OAdT2M1YGPU7eXsg44nw9mQ>
    <xmx:9RARYQ-pV9Ml-XOvzcDCenQ9ADrM9crCzXc1Djxi3SunaNiaraiB0w>
    <xmx:9RARYbUR8RoRAlB98UOYXzUIEVX2CWvxuTa-86DJE8JEIaOdNmRz5w>
    <xmx:9RARYUZE5ygymPEu28YBVraXe_MgB9dZ2l7bIiX_a3Iohc_nJZUH-g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 07:26:45 -0400 (EDT)
Date:   Mon, 9 Aug 2021 13:26:40 +0200
From:   Greg KH <greg@kroah.com>
To:     nelakurthi koteswararao <koteswararao18@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Futex crash in Normal 4.9 Kernel
Message-ID: <YREQ8H6AmD2P5nL0@kroah.com>
References: <CAGJbQdfVXdjcDjwUae9QdWWu8MJM5EamN4S1pQCRZO2KwjeFaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGJbQdfVXdjcDjwUae9QdWWu8MJM5EamN4S1pQCRZO2KwjeFaA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 04:44:13PM +0530, nelakurthi koteswararao wrote:
> Dear Stable kernel Contributors
> 
> Observed Futex kernel crash while using navigation app in Broxton Device
> flashed with Normal 4.9.x kernel.
> Futex Crash details are given below.
> {{
> 1>[ 1383.591633] Time of kernel crash: (2021-02-16 12:04:19)
> <1>[ 1383.597480] BUG: unable to handle kernel NULL pointer dereference at
>           (null)
> <1>[ 1383.606247] IP: [<ffffffffa211c271>] futex_wake+0xe1/0x180
> <4>[ 1383.612386] PGD 130f62067
> <4>[ 1383.615209] PUD 130f61067
> <4>[ 1383.618230] PMD 0
> <4>[ 1383.620275]
> <4>[ 1383.621926] Oops: 0000 [#1] PREEMPT SMP
> <4>[ 1383.626211] Modules linked in: bcmdhd(O) sxmio(C) rfkill_gpio
> cfg80211 ehset dwc3_pci dwc3 ishtp_tty_client dabridge camera_status mei_me
> anc_ipc igb_avb(O) mei xhci_pci xhci_hcd intel_ish_ipc intel_ishtp
> snd_soc_bxt_ivi_ull trusty_timer trusty_wall trusty_log trusty_virtio
> trusty_ipc dcsd_ts trusty_mem cyttsp6_i2c snd_soc_skl trusty
> snd_soc_skl_ipc snd_soc_sst_ipc cyttsp6_device_access snd_soc_sst_dsp
> snd_soc_sst_acpi virtio_ring snd_soc_sst_match snd_hda_ext_core
> cyttsp6_debug snd_hda_core dcsd_display virtio cyttsp6 [last unloaded:
> bcmdhd]
> <4>[ 1383.680139] CPU: 2 PID: 7292 Comm: Thread-48 Tainted: G     U   C O
>  4.9.232-quilt-2e5dc0ac-g33302ae #1

4.9.232 is quite old, it was released over a year ago.  A large number
of futexes fixes has gone in since then, can you please update to the
latest 4.9.y release (4.9.279 as of today) and let us know if that
solves the issue or not?

thanks,

greg k-h
