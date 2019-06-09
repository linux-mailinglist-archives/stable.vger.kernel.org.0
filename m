Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B003A6CE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfFIQcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:32:17 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41799 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728635AbfFIQcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 12:32:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9E2C33E4;
        Sun,  9 Jun 2019 12:32:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 12:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Pvgk+en1XHVi74m/1kDPlUGGLp4
        EGoLK0Yj2cV5WjYE=; b=a5ZDodg9eYwnsRglVZY3mSXj/yO97yOKNlX2MPQ8mP1
        nwEYI3uG5SHegVQfMv7XbWx8ujZT2FJESnm64T7NH5hZDPPUFNUhu5AtouCOiR8q
        USzUk96H0q1Q0zM9MLimFq2YZtg0y/rgmNz8au7B6uVv+Ad7p2upIVeR6mnfmL8x
        LtQKUglhX/RoXluvoAZTooUCxkXCFAN0Y/YpY8yCN7nqtfyU3yMQAnljNt81JeSp
        ksbRiUXlzTOaXHHZMKWSuuuMqria9kaQhV1mp1sXrkY4i5m9V+SV0RzJNUigXR/Q
        h4viD1I8k0yuFymRY6jQSINR99Bq6E4q3pi0CKWuIKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Pvgk+e
        n1XHVi74m/1kDPlUGGLp4EGoLK0Yj2cV5WjYE=; b=V/9dRfGFreAg7q9iwDK2QG
        Vzq3RpP5dqfGjB4KjpQ3LLC/kISYZ1tMEXmY98jauov0wFgddZGhAEc7YvrsElMB
        50NWAHAi6sde7EHAJjnzPoIYa7pb3qiSrHsYlqbwayF/cGrN20sWo71xZcLqGDCK
        be1/KwbAGD1oP3xH7FZ2dnFFr/JV4k1AzkF4wE301fKanXhDddLaoCP993zQ73zq
        jvn9vB1/NPD4uGy3DZmkS7ni9fatZT3J320QFW3HoRFWZGB4S6nDmWEIrOCY4rCg
        5+gNOR3vJsm0lRvVa+KMiHSrf/duqPGzTxmjWFS9o3lG/rgsVwp5u6sbuOgrMVDg
        ==
X-ME-Sender: <xms:jjT9XG0aXd__JgRTcdU8UREcMijSpdJbCKgzZwoRsvGdWdB6qjBEQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:jjT9XIAzCTc45jpWLw0B_o9jGP2DF6v-mPxKZzM7hRmfITMmh-cB-Q>
    <xmx:jjT9XK9g2mAFn-3vUUGW0IkOyZU5mUg5EVbOtrjNbHzxkrqknhFF7Q>
    <xmx:jjT9XLXUD7RLeRJm46wNRev0PvUeNdwuWhcyYd9EQ0muNQPXUQV8xQ>
    <xmx:jzT9XDhh7tjPbpu4ISBLDjJZ90EWtcHn6TuvGrxElFfYhVssgO8yRQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 414C680060;
        Sun,  9 Jun 2019 12:32:14 -0400 (EDT)
Date:   Sun, 9 Jun 2019 18:32:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.14] qmi_wwan: Add quirk for Quectel dynamic config
Message-ID: <20190609163212.GA26671@kroah.com>
References: <20190609123735.24788-1-kristian.evensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609123735.24788-1-kristian.evensen@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 02:37:35PM +0200, Kristian Evensen wrote:
> commit e4bf63482c309287ca84d91770ffa7dcc18e37eb upstream.
> 
> Most, if not all, Quectel devices use dynamic interface numbers, and
> users are able to change the USB configuration at will. Matching on for
> example interface number is therefore not possible.

Now queued up, thanks!

greg k-h
