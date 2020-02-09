Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7D156CD0
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 23:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgBIWMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 17:12:31 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38945 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgBIWMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 17:12:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F74D21A4B;
        Sun,  9 Feb 2020 17:12:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 17:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Fvcj12vyuWMPTlWEoulHz2YHUOU
        6autHTHjUEW/CXiI=; b=C55R7/InKc3QGfhVO0kV1DQ+/Hqzu8hhfAjWKh610nT
        xmcMZLbp3pvtUOdk+jxcMI91TFSpnNfow/rM7BKKHUs3dPXgjl/VtKDsS1j6D1sh
        ES4N8hTl+A3p2/IT49JlrQi2QZx/tq+mEFmFvtMbEdI7NbwJkIbDWfSSA1vCZqp1
        svmSugZZKpHyidf7Qs2j3cUg3KidIJnwEeHVon2omtrv9bojUnN/q2CgMTW8TJwr
        C3UWt+9sKPVp3TGQUGky7QW9vkdCw9jFtS5R6hNJttiZaTzfbxIkirt3B21dWYbH
        r9kUzdFXsDncllsxVwAOa1AwW73RDF8W+T31ZbN3hwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Fvcj12
        vyuWMPTlWEoulHz2YHUOU6autHTHjUEW/CXiI=; b=KVJVXdnfkGuoQP3yxtaUN8
        D62Y8HaWJBNIsIF/KIjXtmt8dX+EnGhe8lNM8KHsnOl8XCisfylXiImdN2B+DLSK
        Bb1yan3B2W0kPYRVmJ5VH3GuHRy5GqnhKH9FvmG61kUSmZ4HUlNjqi1ctd4MDeB6
        G0N4cWJlohoxxYi3afDR4y9jlRJtXB/LeJtiLVIDSMXlC0U40urvwxS+QEBzWvQH
        E5zWlpububAnxa1bx+4fANfEvCZz3cUVLgJaZ4FV0bSkTE3LqnQZvXRrAomwJbUH
        Uzvt6fxT2v9xjP7rSeK/24xrBvde4G24Z4bVaKFtod2EklL9POhv3lvKo3KW7JHA
        ==
X-ME-Sender: <xms:zoNAXl5BZdD5ZCpaB4a1t07SZ32OzMaADiDtbiLW6FN2CHdz22aVug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepfeekrdelkedrfeejrddufe
    egnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zoNAXhpnYQO25bSqaWxADBFb_BUa3Epj3U-ny6oefuEm5aeNCGhm9g>
    <xmx:zoNAXsDKb5Bat588kaogJ5YK_SbSKxrmph0rbSgC6J1ay7hh5qLI1w>
    <xmx:zoNAXocZ-fl2OIh6Byq6YYDo9fVf2LyQpe-myjrCcRQV0lUUmj8fNA>
    <xmx:zoNAXnHYWFUDQqjYs0DVVdFjvTr7amHHfg2ZAjozw3BjJtWQGQaxzg>
Received: from localhost (unknown [38.98.37.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25E2E3280059;
        Sun,  9 Feb 2020 17:12:28 -0500 (EST)
Date:   Sun, 9 Feb 2020 22:54:32 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200209215432.GA83615@kroah.com>
References: <20200209.222128.2247005095295599625.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209.222128.2247005095295599625.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 10:21:28PM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.5 -stable, respectively.
> 
> Thank you.

THanks for these, all now queued up.

greg k-h
