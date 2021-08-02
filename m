Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132AF3DD4B1
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 13:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhHBLd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 07:33:28 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38981 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbhHBLd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 07:33:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7F64E580C2A;
        Mon,  2 Aug 2021 07:33:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Aug 2021 07:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=BWTSW+mB6mKBnH9TpZbsDJ4h5B8
        QPXLE05EUek2jGms=; b=up6Xs/hUJjoyW2cpp8NUU/ESRqrB06wx+AcRREa53v0
        sHNekS24DNF6bjC4M6e81T6ffet4murEwiHa8EWVEzu7wrHCupV/gobngBoJgoRG
        kWnWTiK5Ble8wO8sVTettAzz3F9qZMvtAACrH9dTH3FXE9WacWHRnNPJjUGdforq
        DB7SU+8e3qTbIxqLeJVuiOtXfjx2fvePF+dt5W3SLv+xipQO0mxtOKmIZIWm6jv/
        FELhWL+1Rt4zO50qjKszfWcVyz3oSEwkh4xlPLDpdZM6G94IUyfHlByKfkK/XHMh
        PZsUkqR6fO3NEfxOQHWVgDEFAZazK1JeRmccKHg/Kuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BWTSW+
        mB6mKBnH9TpZbsDJ4h5B8QPXLE05EUek2jGms=; b=oNvLGRyV+3tOOM9Ti7pZri
        RMTQvBNkQaIrBfpy0/fxC8IuAb2lwQ5EvhVQ38IKXYhJQEoHKWQWINNiXGlDyzUb
        pFs8nFMD71+EZYP/47gLtbdY5GzcQHw/Y1UOIPrxrDpJGWM5vHIiDZPDql2gLN7b
        ybl9g+uWMDdXCyJ8MaEtLMQP0kneJ/O3f7oZqtMSLrZkwLGVYzVnsJRo3sbNtKQX
        EyDKsJVB/uA7vMTHn0glk7UWCbnF4iNT4W4zY5DlfByym+HVS2S6t3ciMKrJYgD7
        wCpAYUhRGgKcPdD1q8U+RQHU7RVzTbk0HrpjndqKjsXcWlHbpGKzm7XDyi7S4Pfg
        ==
X-ME-Sender: <xms:_dcHYUZaDJKLGPTMlqNyiMNX2c7F_R_xbYj6WTpoIomGYk2QzRGbGg>
    <xme:_dcHYfZv23xFWTtME3cwKEJwt2zLFWSq9S0GtpTEHTTzlAENqpqrjL9A3dJ2bKR3X
    283T_zzDqROpQ>
X-ME-Received: <xmr:_dcHYe8HLtJNPYtaxt-GPe1_hkN345nRSsxQ6V5ZE__UsscOAU82u_GuAEgIYLf9r6Bkyie9g20SReN4HQ5_IvfQm4FyCdT_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddriedvgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_dcHYeqG8a8EGGmMtq2g-_dj1UGxGx7M2HmZ5srBkSLzbY98BJOT_Q>
    <xmx:_dcHYfpxCHEbF5qK21MDfjCdV9S3cwZz7j1PnobkyVoJUJpSI33ifQ>
    <xmx:_dcHYcS_XRYwLTVum8GlGPZH-t42K5o7Pv5qwTxG4q1VeeMS-hZuHQ>
    <xmx:_tcHYdhCqnyqlhDTtT2Knc9dorkkONlt14exYbsvymmNMBwsMsBJtw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Aug 2021 07:33:17 -0400 (EDT)
Date:   Mon, 2 Aug 2021 13:33:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        "Oli Z." <olze@trustserv.de>
Subject: Re: Backport "PCI: mvebu: Setup BAR0 in order to fix MSI" to v5.4.x
Message-ID: <YQfX+7lC4gtdJPCF@kroah.com>
References: <8735rsyuvl.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735rsyuvl.fsf@tarshish>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:59:58PM +0300, Baruch Siach wrote:
> Hi -stable kernel team,
> 
> Commit 216f8e95aacc8e ("PCI: mvebu: Setup BAR0 in order to fix MSI")
> fixes ath10k_pci devices on Armada 385 systems, and probably also others
> using similar PCI hosts. Can you consider applying it to v5.4.x? The
> commit should apply cleanly to current v5.4.
> 
> Technically this bug is not a regression. MSI only worked with vendor
> provided U-Boot. So I'm not sure it is eligible for -stable. But still,
> this bug bites users of latest OpenWrt release that is based on kernel
> v5.4. Oli (on Cc) verified that this commit fixes the issue on OpenWrt
> with kernel v5.4.

Looks obvious enough, now queued up, thanks.

greg k-h
