Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EED28563
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbfEWR4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:56:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56279 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731206AbfEWR4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 13:56:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B13027BB0;
        Thu, 23 May 2019 13:56:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 13:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=lm8VpHbIpuQwMHBjN0tziI6TTdl
        wbB6bh0SeORq8NZo=; b=BMKhJppV9KpsiI/4eIgW0ClgMIYJwtLWjmnRdcORpSG
        0rk2N5LeU9lTJMHP7IZ90VBaVVnz6SZdo0a1LrEV8e/FBaAx1vraGGMzsWJ2fb3L
        nImYh7c7+eLFBuDYAJucFem1CuX8Mnx8Qrm02NjW//meIqdQ25W4ox9MITAsqfqE
        S7TQe/b/dpCLsnoEwMDr32lpfTTNCNP44XVakHRtLyOxo774I7Vo2EK1+pV850Pu
        rM3I13+SuonfPfsLal9fabNUdhPACsqS5nzpVigqnHNnHf9PZabai5hTQqXLdari
        qBxDtQVYKw0vRkm+tGk9oQ9V1GC4q+1OfIu/0mD4Ybw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lm8VpH
        bIpuQwMHBjN0tziI6TTdlwbB6bh0SeORq8NZo=; b=et/0di8d3UFNDJ3ManU5fx
        5uCFIuhyx1bKudmY59IZVF4LqZjxVXsK9nHue6Ue0AuWtiIBkXR5wMIo04PvNB6f
        lkMOy5roqdIJcbygLvvbydWObPBkwIg3vAe5AAko4vWD2QV+9ZBBqkNRhZ8NoJgV
        oI3tHMdTIjdE1Acyzp2NR339fXXawRTHtk/d/Uv9/uTsBZtRihqhknLpVIgu0Fno
        WN4K2zIJ7I24JwLraJ49hp4YWdS+80Mrt2qI/IR7WDtWJbP9VpwRuuwg2Mywv3FJ
        67O3H3nW+orEcagS4hOkdv08VD1MN4WqeDb7LjpUfFwp7rwJ/fF8FTp/Q7zhaTAw
        ==
X-ME-Sender: <xms:wd7mXAGtdBS_un9IJMHS4kJA9-c4Vzyvb-HA3AbBXHuGfc5h7cAODw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wd7mXAF6aKFN6XptK8rnbxY7QDF0YjTVhzd-KGAs2V_VEh2QHLDmwQ>
    <xmx:wd7mXCTNttP0Z4pCkU2gzF38gEQ0jskrWy-HQiB4aQ-G1xTtsmng3w>
    <xmx:wd7mXC7WzxwER2cGTAs9LZ0XzHqRNIhzKvcmxf8Arotd6rePG3l3xw>
    <xmx:wt7mXNxPfZSkvH5ruRDS9idin3MjCnGRrPXL3U_Q0KNAKw5OHKqX3Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3151A380073;
        Thu, 23 May 2019 13:56:17 -0400 (EDT)
Date:   Thu, 23 May 2019 19:56:15 +0200
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please add 10995c0491204c861 to stable 5.1.x
Message-ID: <20190523175615.GG29438@kroah.com>
References: <20190520163705.GG3138@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520163705.GG3138@twin.jikos.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 06:37:05PM +0200, David Sterba wrote:
> Hi,
> 
> please add 10995c0491204c861 ("btrfs: reloc: Fix NULL pointer
> dereference due to expanded reloc_root lifespan") to 5.1, applies
> cleanly. We got a user report of the crash that this patch fixes.

Now queued up, thanks.

greg k-h
