Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3541F6533
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 12:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgFKKBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 06:01:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41019 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgFKKBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 06:01:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E6B15C0056;
        Thu, 11 Jun 2020 06:01:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 11 Jun 2020 06:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=RRlVNKd3rfj2NE6I716uIoUqE08
        Tk34N6LLJsAx7BpU=; b=OzLDdizEvMS24y+QB7IdZ0Te7/uUMSfGOWjWOZ/iHeO
        GwgL9DSZ4s2LfQcfNvgg/0jJCiVl4NUs8e+fbrDWVsWUykQA6Zo0ENpaxRWQ3cjv
        RBOWGcy5DWR6A4TfNcMsjsQAHf2HPeI702TAKRDzIlJxXyfpo8gKgCM9KbCjPDPW
        azIZ5O8GGQBJYprobCcnAjO/o2LbT3SzDWj81CGb/YtyVPPzvUyMxozk+GA7Zeog
        ra/XpESw0I2JV90zYRT4bA7aE9Vr1B86Zt++NO6YSjEq4InX52+9rQBiCwGxLjSy
        Wr3VzPahBaDDzbrPCx02Qv8Su+XEACJvHXSFHGpsrVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RRlVNK
        d3rfj2NE6I716uIoUqE08Tk34N6LLJsAx7BpU=; b=IzJKo1w4NX8yp5cfiCx2ZH
        G+EN1z/eX5zJTAd8ToYmHBL84I7KmJWiewW+dS+Ujn93bZ3vxYwme1Kwk8VfMKMj
        6wkB2qcEYfsK9jlYUhNS1pIiiiCGOz4d/Yz8A0GmjpaEzzudd67OPx1vKEl2jkJn
        jV58Uj07HD1Kd4hzGAt0milQureHqJjw5RgO9Byp3vT5Ps09NELHjxqnlaMjQZ9E
        a+PEn3L9ua/hRB4m4s6LDI7SFGuUxRRMbbDYOp3gpuTeBvmIYT7R1XX9ZaEdcak/
        pedh0Opd8TXyUVNV3uBYkyL1LsO98aHoXJ+QT86/uTqMUK2xZUW4/K4gi09tV8UQ
        ==
X-ME-Sender: <xms:6wDiXoSluRGELRZyvqPUwS556arkDB4bFWsSYe69tiM22fg03oU8aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehkedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6wDiXlwtZqx-H7FqvmuaXntadGkuy2G8ShFlRPhlmLCzfC87lGV46w>
    <xmx:6wDiXl1QcsQkQTy5n4zedIn8xOF7cf7VZkoqVYiAZSufpztIGKZZmQ>
    <xmx:6wDiXsAxf1kupWn92LJRGJPN7dAbBZ109e9AbP-KVn4Xg_BZ8b9BHw>
    <xmx:6wDiXsu8Hwu38wJXL0HCDpTPG-NPIjtPfV4Cat0lHxUVBh3-BqC65Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA16E3061DC5;
        Thu, 11 Jun 2020 06:01:14 -0400 (EDT)
Date:   Thu, 11 Jun 2020 12:01:03 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200611100103.GA3633912@kroah.com>
References: <20200609.170826.1260208676150237236.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609.170826.1260208676150237236.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 05:08:26PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.6 and v5.7
> -stable, respectively.
> 
> Thank you!


All now applied, thanks!

greg k-h
