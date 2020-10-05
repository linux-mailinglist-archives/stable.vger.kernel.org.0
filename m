Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6850A283616
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgJENCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:02:42 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39837 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgJENCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 09:02:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F135C5C0151;
        Mon,  5 Oct 2020 09:02:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 05 Oct 2020 09:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=drnwMBqW8F4pHQ5dZtk7RBA8EAQ
        k/d/qQEFjnc4Uhas=; b=T8PuIvzNiNzXQZe3vFZp6ULGNO4TS06zT+uwtOsBKJ6
        XkECP3keY5RX0CfRRpYNKYIa0BHIdGvG0gHRT2VMUHFMnQdsRY3DecHcQ/BsBxLb
        jWEJ5zdgxWrTkX1I17UJi6QOFQ5Vm4pB/HnlMBe0d495Sjc+6EAkMWyDvWkm8W/T
        jEYlPCbtZ2wlDa+Gsq53IJEJIYdArgloZWLwcB+S8KfyUwF2yJL7iKHnYfQj87Gi
        eGo2xQKZcwLJx6P25JROt4tlJTCCuFP+mUflcq4/zeOqpj19hBH/+H2t0VfYbJhM
        x+VFMImByAfyPwO0xSVzpY2qYAdpR96cxUOqk2vcWcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=drnwMB
        qW8F4pHQ5dZtk7RBA8EAQk/d/qQEFjnc4Uhas=; b=b5fWkbPLwWGXBladSVCRyi
        vamy+XR3JZj/6oSlxuysS/S31P5ulWU/VUVxMpdDs/MFn18Cpht9MYTH1wChii5E
        Cqafbb8YdbaVv32plgYC9GvYvdOWN6q6c+AVk4fOzdSKXQgZIyUqcBLBSNELxc+T
        5tOaarPR2efujBfv0Ac2s0NtnQdfSdRPMlJG06Mz3AEsjoDTxVu5nsVMKejjcgfb
        nivQNKkklrVR6/ZP9CL207vrWjx8JX3M+lUMdc5DbfOhy9mqUyEecoaO0xfEKGp1
        br7RRcOISU4cBHVnBsYqOeC7BfI0YI3WV8bzRbUPtvHlI1mjTKf3B1rS31/ueCDA
        ==
X-ME-Sender: <xms:bhl7X19ow1Ls2YeXEI2gPD9KdhI7pl7Aq3atd68JGx6I0pHDLywiHA>
    <xme:bhl7X5vmgq6ZpE9sLFHg8pzws_ERlKIcTiaKDAIQ2M1yoimpPk7u8Jv9V5ZLscVpo
    F2qaAQIw5TOuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedvgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bhl7XzDKL-FvSFUdMyKXd5cYLzi28eML2ITNLxlPCK92ZgTegTL0bw>
    <xmx:bhl7X5eiIxpr1PHrVG9LLIMVwbR6CWpzf4gpM7CjUrDceUoNFSP4ew>
    <xmx:bhl7X6Ootzbl1vfHH5ho95DnXG6SaY4UKjBWKXN6uuy8_3Lcc_zLFw>
    <xmx:bxl7X0X9-ebYJCAsEjXNqsLFePQKAnthvKjnHXTlsDaOSpbxHDaw0w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8474E3280064;
        Mon,  5 Oct 2020 09:02:38 -0400 (EDT)
Date:   Mon, 5 Oct 2020 15:03:24 +0200
From:   Greg KH <greg@kroah.com>
To:     "Banerjee, Debabrata" <dbanerje@akamai.com>
Cc:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>,
        'Konstantin Khlebnikov' <khlebnikov@yandex-team.ru>
Subject: Re: block/diskstats: more accurate approximation of io_ticks for
 slow disks
Message-ID: <20201005130324.GB827657@kroah.com>
References: <5556dc903145475bbe9fc5fa7d116a05@ustx2ex-dag1mb6.msg.corp.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5556dc903145475bbe9fc5fa7d116a05@ustx2ex-dag1mb6.msg.corp.akamai.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 09:06:09PM +0000, Banerjee, Debabrata wrote:
> commit: 2b8bd423614c595540eaadcfbc702afe8e155e50
> 
> Please apply to linux-5.4.y. Without this fix, disk utilization reporting is
> unusable, especially on spinning disks.

Ok, now queued up, thanks.

greg k-h
