Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA14828537
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfEWRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:44:37 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60699 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730899AbfEWRoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 13:44:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7696C2655E;
        Thu, 23 May 2019 13:44:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 13:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=I9fLFspQtd9h1BzrnSsw4SE4yY0
        2yHBuJ+TJ4la+/40=; b=aXOvgk4DHXmgJO5zH3M/2IeWnDuvcLzy8fTwUy6bSaz
        SyNUr0dHlrBXx6D9ucAWF632kkiJyuDC1xN9u1qvOLbZZLnht/6xHLctNC8e9et/
        8SNA+VYuBlcmI45J3LrzDthwKXE+siHJAF5R8JqdXgu0ZSOhUDRmhfQySQ3Cp3fZ
        HtWIdThItQMxdcu8wQ5rMpLpUaUjXx64meBFYsGJvG98N7SeyEh8yn1vlGOPCxqa
        QyPQ2+kc3x6vCY191uk+EDHAEI03v/mg3TqgTTEorPOVe5GiRK+qIO7/r/Dhp54i
        D3lw20+859Q4YeRBc7p35MJdMz0FjWp/jvhcUu/sGhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I9fLFs
        pQtd9h1BzrnSsw4SE4yY02yHBuJ+TJ4la+/40=; b=Z3CXT1Sl/3oc4dOFbPMsKC
        sneJOScnZFRO98XPmPM9xYLb6MAZn2Xu1l3GV+ouuJkjbEmU22GRRIMr9zJSv9tA
        1N6WEGt0K+LrHKkw0ZhuRhbWxmZJNYDsYwLayN9863Zfd3bGNLoH2rerxq/bPpyR
        NoIvgFDJ6Xltkt+z7qE4osdp8zyTAE08lYILGi4K9xdR1GzmqIwYbVz+6Cd9urGq
        xekRqN/ycr+kQD3PjvcmzrkupDbfUpQWHv3uUKUj+qOA7SvO1fvWRDEZJyN+K5U1
        nMp6abi5dxIX2lFyZRgwwOkncpxdpmc8KNYbqZ17SYysZDirG28G84Nq+roLWucA
        ==
X-ME-Sender: <xms:A9zmXCxiVzbihE8cGYydrWZxAqSYvHYqdPdYwPXGlkcQCYu183uBuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:A9zmXDpo49WAh_IRG3hLylnJ-rS2PPOKNlpbZGpJqYsy2FUHUOYBsw>
    <xmx:A9zmXEhjHN5hV4sCBOBJ2kexM5lBdcDLe0-BOxPYK3ARLZHMRXDFiQ>
    <xmx:A9zmXIiIu6xOn2MsdNr27Kbnlak39XiKClvSumvCv-M-KVqDLgZ2CA>
    <xmx:BNzmXHfLWQJ8atrKcrhHzkeO9dQs7n8nZk5DlcrdQRLq7-fno_6qrA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5795980059;
        Thu, 23 May 2019 13:44:35 -0400 (EDT)
Date:   Thu, 23 May 2019 19:44:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
Subject: Re: Fix bad backport to stable v3.16+
Message-ID: <20190523174433.GB29438@kroah.com>
References: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 04:30:33PM +0000, Song Liu wrote:
> Hi, 
> 
> As reported by Thorsten Knabe <linux@thorsten-knabe.de>. 
> 
> commit 4f4fd7c5798b ("Don't jump to compute_result state from check_result state")  
> was back ported to v3.16+. However, this fix was wrong.  
> 
> Please back port the following two commits to fix this issue. 
> 
> commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from check_result state"")
> commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after the parity check")

Added to 4.4+ for now.

thanks,

greg k-h
