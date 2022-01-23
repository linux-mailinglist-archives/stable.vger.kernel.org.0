Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8DE49722D
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiAWOmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:42:03 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36207 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233533AbiAWOmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:42:03 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C05615C00E9;
        Sun, 23 Jan 2022 09:42:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Jan 2022 09:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=QpYsK6cmEZqFm9762MsExi1fKeg5gDFyZHslH4
        2yQvg=; b=wUPpn5lC+AzuQL4eGibRCUdtWQfsIrmswR8maDHCjUnocWCx2jCwM5
        M5ucOuF6Fq/3dpUTVKlKWJVhem1TyxCV7wTLwmACKklRyj27hm5QxCzknuq5wjuB
        3xlLuouMoWvByWm4RyOXz8OJvnLedUHvsv7UPbEv3jCIq1MZC6O12pDqLRZfDVPE
        FFuS8FQklTtHGIQJXYnFtAgKiTYbdQZ//kJgOJWuBIIIt1WV5YV0fzSO+3D4yycC
        8czyiRmRbwOgzqkcL4sznsIXcR8Vf94Mj5kQfSu3l/QKMh3otntUZ031R5Kga7T2
        jEAMQ8SLYb1EHNa2qFcWfQtoEXpSa8mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QpYsK6cmEZqFm9762
        MsExi1fKeg5gDFyZHslH42yQvg=; b=ipEUq5wpNN9jakOZwq71REYu3zZmRgkn8
        gM97aJ8ayTtonOb/d5ydvMBvTXdgJxHdD0/mWc/vfba3BQjd78wVt/G673Q8rUTY
        yt4zi8LBRx3BF8Hbfl52Cp9A38Bwxx1kSSQ82YHB3TPdOrgZkOhVOvSZkb9RlgIA
        2F1HqmCrfch55q7BdWkyNDFi4qW6ZO9Y92zl3qZ0bPjOfpU6loHqUQ0zpiAZ2md6
        a22ubUFB936OUiOU67IkDF5opIlWK6gGSCFmZWtr8GfMPBGMUVTKanY5DeBumv+o
        C70MlzAFBpdf0v3UnEBWBky6z/G/kc8wSFHDP7+ffpcjsTHrgwVNQ==
X-ME-Sender: <xms:OmntYZJ1I_uSdOf248gL38IV1WY6uhHg1j_QY1IagQNrXvp0h8QoEQ>
    <xme:OmntYVJXSBCIscSbXrHGqdHklT8zSZPJeG44QH6iPLQb_I0oCbzyFWFL9YEGGzw9S
    ycTVKekp9pqkA>
X-ME-Received: <xmr:OmntYRsyOYCyfBRtqmwWmXVyzb13p41I5jhB9U4QdfieJBPXCF-4S2Y6hpUKjtiB7oFYvDUUsM05bh-SvDwnmukGFsVRk0OE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OmntYaYDJturl4bGoBMxO-NoyIg3ZyyIBOqhyZVo-UXEkODIaa81rA>
    <xmx:OmntYQZ2wgO4jxTwjBUJQ6tCr4VpKrOnRxpcyDd6YiolCUL5p8vgjw>
    <xmx:OmntYeBARNIZAkiF9OyJ6s6gg5_Tdg24AafGnl36stH5P3TwlyLJyQ>
    <xmx:OmntYfn9B8nl3CTjMQZE87gmoXtBJue_D7n7Z-lvoffXOhn9-nMZ8g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Jan 2022 09:42:02 -0500 (EST)
Date:   Sun, 23 Jan 2022 15:42:00 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Make WCN6855 work in 5.16.0
Message-ID: <Ye1pOHGQDOMQj+y8@kroah.com>
References: <BL1PR12MB51578314DF452921CDC3B192E25A9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51578314DF452921CDC3B192E25A9@BL1PR12MB5157.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 07:42:35PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> I found recently that WCN6855 even with the latest firmware doesn't work on 5.16.  As a result of not working it causes failures during suspend: https://bugzilla.kernel.org/show_bug.cgi?id=215504
> 
> However the reason that wireless isn't working in 5.16.0 is because the way to find the board IDs in the firmware binary needs modification.  I can confirm that it's able to parse once
> commit fc95d10ac41d75c14a81afcc8722333d8b2cf80f ("ath11k: add string type to search board data in board-2.bin for WCN6855") is backported and that avoids the suspend bug (that otherwise still occurs when no firmware found and should separately be fixed) so I think this is a good candidate to come back to 5.16.y.
> 
> Thanks,

Now queued up, thanks!

greg k-h
