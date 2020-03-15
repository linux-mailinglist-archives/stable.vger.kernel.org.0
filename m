Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0275D185B3F
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 09:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgCOIg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 04:36:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45927 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727954AbgCOIg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 04:36:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 78E8E21F41;
        Sun, 15 Mar 2020 04:36:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 15 Mar 2020 04:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=JnHhVjXwthjleb+oaFtzrpG/tkz
        1+HzQYOvyqeBChJI=; b=eOVdF9ocBEdCLlx4uXDZujeqv8i0bSeSNgFVJpFxt8s
        GIWuLhorDIr9VFLoWo3RPGa/nNOHtlRSBofVd5F0/iqt2asikNQ+2phSpaWrE6TM
        qNK31CPShBYlyuzeXVRBDn9tM3QBg6XsLxdnblsN3khfoWbXb9CavWiasREpiTTF
        Wtby5vAafVQOhV7HaBARuRj94t1C256V9H92yZ3lc+J5T/eoHBONqkklhtHsc5Mj
        h4a+2Wzgr8/OeeCxw2UhsvO1DBJY41Ri0Z6/LhtIQDIXMlmpSebp2kK4XZDJ6ygf
        kMYypTpJzYNJZl00jf3yeY8ULh/8vYWt1hs5uvRtplg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JnHhVj
        Xwthjleb+oaFtzrpG/tkz1+HzQYOvyqeBChJI=; b=K/TMNIZ2XSkO4OEFOXcyIZ
        etcEKdA/XRdfqC4HeWPA2tuqzVhDLieBpFESCy4D2hCY1dgkNlz2+Vjes3pLXfXR
        VK4G76nu2C430vx1Hc8PBs5vd28Wt0OU20Bz1QmGZqgO0x3hWrdz0K8s5P/6Hziq
        BJWtemBxlCWk+hn6u8Qvyc2C4NwYt2lGrTUS67PqaNG+Ccw+/vSTBaYiGSiJTPQo
        Yg4HrR+FoQNLeqrHbTZytZDhxR9kxXj7BDCMsDyh1OjmVyFk5KzkcoaubyLUfQ2Y
        XM3pm0IvcxXglbCM7Q3Kd24pg74CaGcEs+KdAE3oWtM88mh66h5G32lPPROFpbuw
        ==
X-ME-Sender: <xms:KeltXiLVx5osqGsKy0UV4e6F0cfeUZ6YJnzNzTeZBpolyIMM8mS7Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeftddguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KeltXlh-1wSj92EF6okbErhEcJOxoR1-VC7Tk-GOCrQAYvEcZN38mQ>
    <xmx:KeltXgfey4PKrNIDCvMvlTpvcPIvL7OiY00rolIFDrIHWP4nsxfQqw>
    <xmx:KeltXt4J69UKMMCAQjyouhjkp92jCcv_LS_MX6T1nF5yDHBAQyNdnA>
    <xmx:KeltXif3FydmqQKSEONvi9j1vPFYOxVHzWWk4SU5T-8T-NF2We8cqQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F1CD630614FA;
        Sun, 15 Mar 2020 04:36:56 -0400 (EDT)
Date:   Sun, 15 Mar 2020 09:34:42 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200315083442.GA227591@kroah.com>
References: <20200313.215204.129234716151770482.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313.215204.129234716151770482.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 13, 2020 at 09:52:04PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.5 -stable, respectively.

Lots of patches this time, thanks!  All now queued up.

greg k-h
