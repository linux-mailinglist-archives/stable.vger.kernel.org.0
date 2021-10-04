Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D5142097A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 12:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhJDKsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 06:48:23 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38721 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJDKsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 06:48:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5E8A8580B25;
        Mon,  4 Oct 2021 06:46:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 04 Oct 2021 06:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=irOO7ONR0hO+Moe1OulPGA4Sflz
        XE9CcSAgw1vjrpuY=; b=Vpegts471EGuaLcaEzW4bMLz+xQGbi6H4DYmeN7f07D
        pZFVPXNq91Ltai/K2K57/TE6WtQrKW387c0DVuof6Ym9rlw7TwSyBDrojzsYLHej
        1I9hD0q6H5zqsfnKpusm1OHCkyojW0eJMGgsXjLW69r6o8xmYSRukZR+LPR5pu+f
        /+TKJEvlWBE5LdbDRGaF4kPIogbjAEDfnagWeOLSTpMNrZIXc0E1bob8a3CV+51l
        wReas+1SRERSj1cogd/MyQLmfK/Tybmt2x25tXG07XUe5nqMbFrIz470yJc9MKKw
        uOyxfM2GjNoseXuGspxHOPt+wL67Rk+/GO7TAKVxpFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=irOO7O
        NR0hO+Moe1OulPGA4SflzXE9CcSAgw1vjrpuY=; b=lShJVs80mBQWuOEr4ERpAc
        cBxAQDBbJRBEMMHW3I4T9f/yTP5wGKaK8n61XFjpN5mGtm/Sd4WfdXf51xl4ZfVd
        /EAUCp1N0AEx5XsYHKKaD3lrMXgeWc2jrOCp9p8/WCEHJm6gnO9FIF2CYJAhEymh
        cOKxbdzHHSKHaXeU7k1aoXTqmKeRubQcW7+QbbJAijRGCSjNr4kU0hdJsGyHw2KR
        HhdaiU94dnm2fXbs6LlRAXvUTX99HToFOQ2JweXVnf0UlZ7hlxTTnh60dVnc6V/k
        cYgtrfb9tqQTJR2U9nME0mUJ4X9tqsG2WscDlKX/nD5uPt80u0cjydEyulgrjTEA
        ==
X-ME-Sender: <xms:iNtaYZWmkKGAkSrSoa7ymZkm5aObDSsd5yQOcRuP1_HHJlhDn5-DNw>
    <xme:iNtaYZnnks8Cem1t5UI8ginHJDvepnH0whFEPByL8hbLdIzI3mv_zPuHyPvswiI6h
    Vyi-Oek31AfgA>
X-ME-Received: <xmr:iNtaYVZqDISs_FSjsFFvdZbR8W7qZte7RWSrx16tnhziCqHv1vVUhKONRNs6Gsz9a41xnMsHaPCF1m4PVBiThBpBljtGdmCM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iNtaYcX2_UCqPZ7LIjiamV4Qqcf7Cc4gpu5g4GOhQpMIJ9FeSLC75A>
    <xmx:iNtaYTnUtmebg6H4cmTsZmMw4Ph3vKx6qOZmInYQ-3r2bFAtr1KkWg>
    <xmx:iNtaYZcu9v4uRMs9z7uRCDrG-as7VtG8z8sY84TJUCXrVsKX48giyg>
    <xmx:idtaYW8ox0tpIJoj41Q0TGm1NT0N3QFC4XdjnFhKUYY1s8Um_MA5RA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 06:46:32 -0400 (EDT)
Date:   Mon, 4 Oct 2021 12:46:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.4] PCI: Fix pci_host_bridge struct device release/free
 handling
Message-ID: <YVrbhVDiLcXxhQ9s@kroah.com>
References: <20211004060838.678790-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004060838.678790-1-tyhicks@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 01:08:38AM -0500, Tyler Hicks wrote:
> From: Rob Herring <robh@kernel.org>
> 
> commit 9885440b16b8fc1dd7275800fd28f56a92f60896 upstream.
> 
> The PCI code has several paths where the struct pci_host_bridge is freed
> directly. This is wrong because it contains a struct device which is
> refcounted and should be freed using put_device(). This can result in
> use-after-free errors. I think this problem has existed since 2012 with
> commit 7b5436635800 ("PCI: add generic device into pci_host_bridge
> struct"). It generally hasn't mattered as most host bridge drivers are
> still built-in and can't unbind.
> 
> The problem is a struct device should never be freed directly once
> device_initialize() is called and a ref is held, but that doesn't happen
> until pci_register_host_bridge(). There's then a window between allocating
> the host bridge and pci_register_host_bridge() where kfree should be used.
> This is fragile and requires callers to do the right thing. To fix this, we
> need to split device_register() into device_initialize() and device_add()
> calls, so that the host bridge struct is always freed by using a
> put_device().
> 
> devm_pci_alloc_host_bridge() is using devm_kzalloc() to allocate struct
> pci_host_bridge which will be freed directly. Instead, we can use a custom
> devres action to call put_device().
> 
> Link: https://lore.kernel.org/r/20200513223859.11295-2-robh@kernel.org
> Reported-by: Anders Roxell <anders.roxell@linaro.org>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> [tyhicks: Minor contextual change in pci_init_host_bridge() due to the
>  lack of a native_dpc member in the pci_host_bridge struct. It was added
>  in v5.7 with commit ac1c8e35a326 ("PCI/DPC: Add Error Disconnect
>  Recover (EDR) support")]
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
> 
> This commit has been identified as a fix for random memory corruption
> that we're experiencing in production. The memory corruption is easily
> reproducible on 5.4.150 and we get a nice KASAN splat that led us to
> discovering the upstream fix that wasn't marked for stable inclusion. I
> don't see any obvious reasons why this wouldn't be a valid linux-5.4.y
> candidate and hope we can get it applied there.
> 
> I've verified that the KASAN splat goes away and I don't see any other
> evidence of the memory corruption issue once this commit is applied to
> 5.4.150.

Now queued up,t hanks.

greg k-h
