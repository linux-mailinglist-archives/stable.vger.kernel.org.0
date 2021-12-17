Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8337478EBA
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhLQO7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:59:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52093 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237575AbhLQO71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:59:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A849D5C0206;
        Fri, 17 Dec 2021 09:59:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 17 Dec 2021 09:59:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=oJMQlrWYn25NFJxuJcbzG0IN/2P
        7X0zckpUe3BJLjjU=; b=dYgUIFz0uVl6km+2YxwB3rKbCz3fhhIaO82+E/SnNTj
        cu2Rqs+MvwRUamMHxJcJvtb/AAA0bLKwUVgFUkQ7WUgOXkbw5pqAu6vE2V3b6byd
        MZVPM30Ii4wr2eGQw/rjs8zdi6ybHgVr/enSjedtYRtgbfSh+h4Y1IrPQMV4F0cp
        odDdUHgkat+GoL4CjrtspJWY+e5d+SGJoJBLF1JDDipdP7ThQqOcnF6vJv+2AdMG
        xGZszzn6YbqYfxw03pDHlJBN+12pWtQ+On4NMNZhnJcMtMwXlh2eKmnuBFe/gz/Z
        YD7bK6R802PWQY6NBltDH4tgB+iE4C7+YcHvKO8S+aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oJMQlr
        WYn25NFJxuJcbzG0IN/2P7X0zckpUe3BJLjjU=; b=AbTEBUFh92SC5Ss3R5GjfL
        AeA+W0EoEYxCdaPETROqEyZTIMviNqQ7ktXvUrIfn070PFOGLXJ8Y9iLiIvwPQqg
        pwudLH2ggSkMnZDuQIhYv7jx92k0dPcGeCHqGRpgSHwZiMfYTqFujbii7y4j5anp
        oUi0JPY7mDhR+iE0HXPDW2i9LbuSJ7IQ5asHQ1sv1SuSHRJgcUo5hGIF6KX8TlO7
        SKoAmcmfCNw1tomFCowbtMaF9EPY4zGBx+KLjwiDsSl7Qo/NQzJHnpO9RQuBFauk
        iKTY6YhWmH+9hfTXupSeqXBb6MO/ErZULGz6eJnRaXiKiM7XbANo9RKG1dp7bJ/Q
        ==
X-ME-Sender: <xms:zqW8YaJCH5hnO4qGubPIyfUomZQt8Xcoa80_y2rdNs59NL2uPo3fZA>
    <xme:zqW8YSIHewzTsf116agq6jTHm87GT0_8gid0aGtsn2vuYIFyMhjOSkkz8erVnRQWT
    jAhQqOagQgvVw>
X-ME-Received: <xmr:zqW8Yavtgt9j5kmqpw8pDFYcte7Y_rmCcXBuMZ4tN96l9Rfkuzn7jsUAz0OjJ77JHjmiDqnXBJrEM7LaiO4bnf7fT3XkN6nM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrleeigdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zqW8YfY_znR5G1sel5c4h_c9yvzbRBuDHy1xwVsLp7oAZBod5ZZN4w>
    <xmx:zqW8YRYEVJCtStfa1Bgv8hYUIGrZ7M3Dg2tnTZopC7qYMxHzYvj_FA>
    <xmx:zqW8YbAdoEjiuR6oqmC_7BFDVED22PRrOY9_1b4AKpfISzMnXzVq_w>
    <xmx:zqW8YQk-V8fVp_8boVk0ffPf_L-0r6nreTjEThXKJaG6Biiq0ccNVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Dec 2021 09:59:26 -0500 (EST)
Date:   Fri, 17 Dec 2021 15:59:19 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Message-ID: <YbylxzdXPpH9leTc@kroah.com>
References: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
 <SA0PR12MB4510B62D8E36E908364FED36E2769@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA0PR12MB4510B62D8E36E908364FED36E2769@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 08:20:54PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Limonciello, Mario
> > Sent: Wednesday, December 15, 2021 14:18
> > To: stable@vger.kernel.org
> > Subject: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
> > 
> > [Public]
> > 
> > Hi,
> > 
> > Can you please apply
> > commit 2d54067fcd23aae61e23508425ae5b29e973573d ("pinctrl: amd: Fix
> > wakeups when IRQ is shared with SCI") to 5.15.y?
> > 
> > This commit helps s2idle wakeup from internal wake sources on several shipping
> > Lenovo laptops.
> 
> FYI
> 
> To help prevent certain rare configurations having problems it may make sense to take
> commit e9380df851878cee71df5a1c7611584421527f7e ("ACPI: Add stubs for wakeup
> handler functions") as well, but this isn't as important.

This is already in 5.10.84 and 5.15.7

thanks,

greg k-h
