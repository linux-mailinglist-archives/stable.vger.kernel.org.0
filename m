Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B84114C88
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 08:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfLFHJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 02:09:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48277 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbfLFHJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 02:09:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B53F120A34;
        Fri,  6 Dec 2019 02:09:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 06 Dec 2019 02:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SE3PRRsnCFQP+BXMvSJbVatzNAn
        vG2jlSRLUaaaPD0E=; b=iDCSY9zMlSMfJFUvmOhdOH72dD7NhwNlYIHcaUnbNIc
        lFJgAk2TTwHFtqfJ89HRZgBmPUyYbka+r7ta11c6p/Dq4x81it4Y2sZgiwv6QCJR
        MBGvZx5zYIGP/cJ/Hdclao9BEQKprmLW2bBjFMxNV7qSzc66MS3w+k+DcHcR78hz
        czK9HxTikZbqEMG7trEbiVS9UM/z4h84fsXrMgMv+birJfq/fScN6yqU14NPtHIP
        aFSD9a8ovFI7rOiAdy9Jr1LqjIJZUtWsyipaAEtKQ7rco2vZfRwFjqo3ZeivdQtR
        OojIcbg0vD4C6xqQaNEjQsGbQCoOHx5ntLnn5EhOAAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SE3PRR
        snCFQP+BXMvSJbVatzNAnvG2jlSRLUaaaPD0E=; b=IzhoYnyqXPLqE+TkWc5KCP
        DPq29+8OR/SWUbs+ZTm78Dr5G/yOov7E34nMyeUxckSqo2yqoIpS8DYUoFs1DHrF
        ZT8fipoVqJ9KEHNP7w0NzHJQA0XlslehGTNfMUVrwQLZA4YBoltqJuAQpcqpmr36
        4cSDCzGfXZbFZjdfb2ySdjAl6vkIpkot8CAcIYO8RGqw20ji17E/egLqTXQNQKbD
        Hmspn4pM7thOnAV5TSigzHgoD/ydi8oKo8xhij2Jrwl6ozbIMOpB5XZPrx9qYuHA
        p9S+CPrJONpPZ937Cn7suxJgG1YUMBXI+UfzaFQSmBgAhLKqney54yVm+cH+kyBw
        ==
X-ME-Sender: <xms:mv7pXbsXHAv-umzzx4cBKO4f8XYc5tmzC94Ap03KMCA6Q_vIDiLD8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekvddgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mv7pXWtVnZ7sUHAjmBya0TZDvq9A1-LfPXA6ADC5JLlamjeHVvBRWQ>
    <xmx:mv7pXdsspGnDlRqhzo0NqW1rik0SkPetk_0j30sAXSks0j1w9HMQMw>
    <xmx:mv7pXR36Vt1gYydQ2FwTaSuHHA618B_kR9bbzjL7O2HHQKgFW1oZEA>
    <xmx:mv7pXYp91H8-wM1nqAS2OmIlWdXwU4g_shN8mNfft64EIE0wKpLo4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4484D30600D2;
        Fri,  6 Dec 2019 02:09:14 -0500 (EST)
Date:   Fri, 6 Dec 2019 08:09:12 +0100
From:   Greg KH <greg@kroah.com>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
Message-ID: <20191206070912.GB1318959@kroah.com>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
 <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 06:47:12PM -0800, Sowjanya Komatineni wrote:
> mclk is from clk_out_1 which is part of Tegra PMC block and pmc clocks
> are moved to Tegra PMC driver with pmc as clock provider and using pmc
> clock ids.
> 
> New device tree uses clk_out_1 from pmc clock provider.
> 
> So, this patch adds fallback to extern1 in case of retrieving mclk fails
> to be backward compatible of new device tree with older kernels.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> ---
>  sound/soc/tegra/tegra_asoc_utils.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
