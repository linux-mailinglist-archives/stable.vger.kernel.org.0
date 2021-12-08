Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6756646D3E7
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhLHNC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:02:27 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51473 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232257AbhLHNC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:02:26 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 891655C01F8;
        Wed,  8 Dec 2021 07:58:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 08 Dec 2021 07:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=mvx6K+D9MdBbmewV+L2aWcNX8ry
        odOnQHP9XwkfdoFg=; b=IaXiJLFzKwLJ+96yvvorLAPcwqkFMU32VIVAwjd2Xla
        CuyWJC6uxBdIRFV91kn0sPfMmVKGxG6vUWCMXwO7PWsMlh+vCCsk6U5b7s6fLqVw
        7czCAuJe7yD/a1yk5tPTWuUqiOgD7JBrtkS7XvJ5pxWYKdCkaQeIr6y53RDdeD46
        /mopYFY3jPAFtmVbM78XIg/5agV52zDDdmC3nx+NoBAhydKb4JyOJL6FMcPPC5k6
        /QOVriZU/z5Gr7cvvMImWca3prH7uvTV+vkXZI2BXg8U++FhXGSLuLfm3P0XcRSP
        5GZb3VYmaXu2ElNja1OBzcd/dtH/VcrDzLq8shUDKhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mvx6K+
        D9MdBbmewV+L2aWcNX8ryodOnQHP9XwkfdoFg=; b=RLpzVcwGiOnCQzwppZHbSI
        padvQ+ZkgjBjuOrsKlepSyNiGJL9K2l5OUJ3tJ9ocKkN1evyUOSn8k3DDwUVziEC
        j0ZngNraoIu1eyiFJ//87MYbHTdy/EZVITmBPRJBs2oV6rucaGHrTNHV9SsRmfWC
        d4/6ti3GgDZIuEW26PTbKIhVaKX74jCBiYc0Cm6wHYbHgxrD1t+9YpBZcRSjawPM
        gs2040I22cnG5r2AoemIcW076RhvFJ1Ks11EXzdZp9QWMQs7uf4zEvsZ0bLI6qNq
        8+nFDUYKw7+Xy2BGBmQHjdX/pFaGkgWYrMVSE/kUjyw5seJFrNLZ/MzSdbTD8WTQ
        ==
X-ME-Sender: <xms:DqywYfzuFA73za7ZTjQkP-j4JN2Tl5VJF1TrJ_Ymy5pBeAOW9EtGbg>
    <xme:DqywYXRF5u2pXUQes0YDvp9-LuRB8R7su9WqO6t72Kcr8Z-VWaMZJsuYpBtRykrJC
    s9MnHdyPUy9Bw>
X-ME-Received: <xmr:DqywYZUiwsNIgwHnUx77geEeACzhiedEEwaZaprrWl7N-CmnqlBdqsY69f5mbYYnuLopiiMU_6TCaG_WIPOh2CXeJE-Fjz3i>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejieeuge
    egveeuuddukedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DqywYZgD-iC6OkjJSxCn-6OEPvN_CANkwOPATzI-9ndtjXvZdD-nNw>
    <xmx:DqywYRDcEQbDiQkjbAvd3JZ12TPix4TUuE3XkYpjOZiCpILxIt8oAg>
    <xmx:DqywYSKv9-BaWcH4Yvk-66uA-k2tVPmgkY2kYtTtpQlyjZnpdsBeEQ>
    <xmx:DqywYUNbFlsDNY7RORGhdQCk74SGzvq9L7AYCm9x-ySXf2BfpSQdrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Dec 2021 07:58:53 -0500 (EST)
Date:   Wed, 8 Dec 2021 13:58:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Dan Vacura <W36195@motorola.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: usb: gadget: uvc: fix multiple opens
Message-ID: <YbCsC0i4VpQW2YPE@kroah.com>
References: <PS1PR03MB360765EE2F51F5A44F80EAB0F36E9@PS1PR03MB3607.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PS1PR03MB360765EE2F51F5A44F80EAB0F36E9@PS1PR03MB3607.apcprd03.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 10:53:44PM +0000, Dan Vacura wrote:
> Requesting 72ee48ee8925446eaeda8e4ef3f2eb16b4a93d2a to be cherry-picked to stable 5.10 and 5.15 for use on Android devices
> with external camera support enabled in conjunction with UVC gadget support.

Now queued up, thanks.

greg k-h
