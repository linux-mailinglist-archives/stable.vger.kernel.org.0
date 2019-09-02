Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03949A5D14
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 22:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfIBUX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 16:23:29 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:44679 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727192AbfIBUX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 16:23:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B5E9C55F;
        Mon,  2 Sep 2019 16:23:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 16:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=UWuYiigYSRxHXgn1gJTDhgzrzny
        oIUbv1dPPzOc3oDA=; b=gaAoW/odJuIi27oeLuy9UHyPCflDXyjafxBOqIGdh7r
        6vVd1COupF/lVrlcqF40s1ISSzlRzwUiK1bY0M+RT+JEFeW60LyuhJFd2RbhM7lL
        NDqjn0TVJsJuojze5FyvSQMrZgOMgOmgrf2xpn1Y75Qlaea5JUng5j1iSDUu0AAu
        N2bP70IBFNz9Yeqwsum0zx+aIJ5mGYQXKgkICHq4WaZD0XIQn5N8aa8GZ6SC/sul
        zXtosvhCgyhQWKxaeGYhtCp6WP2R0mBeFaeFNOU5x8Y7bDoEaMtU8O2viee5Q/+1
        EKzvYYF6zA9YKVns+KtLubI8+xRxUEdWpcLyn0SyoXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UWuYii
        gYSRxHXgn1gJTDhgzrznyoIUbv1dPPzOc3oDA=; b=VpL4uHEdWGjqpbH4w9UvCa
        bsby/uYzZgVe8dUdxXh21nfUDg5kDVgKDiLff3U/GROEfACuPL3A8Cco9MVx4uF9
        gZyHpQXtpxaimNHb2aL4Aa7accegPESujp5xiGKXaS5/NYl8vfQBwKEDapuqqdPZ
        EvNArpJipH0/93atWqQEIOkUhuMBrBum1jdayduBLkFv+m9udbey3Yh3jVdOmHaX
        4oCjtfyCowJRUbPhd+F1YzIcRxvrCa+Wt6fBtcmPH6Ci1Ljxtq8WM3POEaWuKWq1
        WGJAWKAxHxmHvO2hV80jYrU7FD3psGJPPgGcKFiJ9KHWll6T50mMy/eZirre/moA
        ==
X-ME-Sender: <xms:P3ptXb6OV0I7izp4yP9R1laZ5I4mBuCboTlzZEgTVE87VL_jR4kVNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:P3ptXVJw0-WDZHRwH4oCehYbpW2hB6bZsIk5BPi15Fxw3q9Eu1J7nQ>
    <xmx:P3ptXddrMzv4uG8RtYx9Js8WkMocXHzVoUHdQo9NIUzhjaxDHoG9zw>
    <xmx:P3ptXQce-1LqNzPnlyNbGvwmmfaKakhfowGU5Vu3-AY3rZPTs9EPQQ>
    <xmx:P3ptXT-pQpYZtEdVaF5WlvwRRYLPveHY_pXXj07eeTftHUFu7O4PJw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6720D6005A;
        Mon,  2 Sep 2019 16:23:26 -0400 (EDT)
Date:   Mon, 2 Sep 2019 22:23:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Bandan Das <bsd@redhat.com>
Cc:     stable@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: kvm: x86: skip populating logical dest map if apic is not sw
 enabled
Message-ID: <20190902202325.GA31701@kroah.com>
References: <jpgmuftvbuf.fsf@linux.bootlegged.copy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgmuftvbuf.fsf@linux.bootlegged.copy>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 06:11:20AM -0400, Bandan Das wrote:
> 
> Please consider
> 
> commit b14c876b994f208b6b95c222056e1deb0a45de0e
> Author: Radim Krcmar <rkrcmar@redhat.com>
> Date:   Tue Aug 13 23:37:37 2019 -0400
> 
> kvm: x86: skip populating logical dest map if apic is not sw enabled
> 
> 
> This fixes 1e08ec4a130e2745d96df169e67c58df98a07311 that was introduced in v3.7.
> The bug is that the KVM lapic is not considering whether the guest apic is enabled before
> populating the apic in the logical destination table.

Queued up for 4.14.y, 4.19.y and 5.2.y, thanks.

greg k-h
