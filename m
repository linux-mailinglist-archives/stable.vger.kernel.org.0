Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1BA189BB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 14:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEIM1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 08:27:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57517 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfEIM1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 08:27:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 151A02361B;
        Thu,  9 May 2019 08:27:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 09 May 2019 08:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ltp4ni1Ora5HFHnaiZxZnWi+Yoq
        Zauo3iDApRUo7CfI=; b=VfuYiQ1dadTk8ZuULQDmQxBDCD5SeWlDBap+e/F7yMT
        pnkKb0dmTARxy1D1WLJgaAbXSJtDdm/wbOY4XmRVG8ZuVgqKCrTy/dvFPOllqjEW
        JLCY5mNU+FS39aCYNnWdvSC3wBApzegLoKf+2m7F3KJbROx9dLpdQmEqiePOecwO
        HUB2X8QzYE0epckSp6ix2pr2Kr7yeP7suLILlLhOSy6P+f5e+/IBoAbsyNZEdeS4
        Gr1EKv2FLpAE1tqxLktj2VGRW5aNBaVtw2KNTlqe2ynn5rPpyFOregv8zB+kiUry
        Iu8+0Vur4JyJF2WGmwtGTEH8sUSWzGMawETLf4QXz4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ltp4ni
        1Ora5HFHnaiZxZnWi+YoqZauo3iDApRUo7CfI=; b=l5p2igW8SsG6OtNQDLUW2I
        iAZiPZE/xWhsREBuWtU/7dTov5mtFQOVkKVjGXcify6qpIbdlKODjkPmGAYgjCfy
        aBA5USfQtqauaD1hGkvQ2mySNsU1ze7JpebKcH12kACAxwGNYmlvQjVWArgRPEsc
        Foons202CNsu+jqq8xPy+OH/UnfK802Q/1o69hm3w5lSYXpCX1LmVsTCpcek5/bg
        q4jXDKPRS1sOEmeqbAHPmADFlRqUPOlFPI8mp6AGAcw2/QL/FxU2FgAyMVOkWZ0V
        e29k8fIjy/LDFHgl749dxZikAGakHDx8iVQoBee5OvLA5Dj+GIT2ngE6fYTseYew
        ==
X-ME-Sender: <xms:vBzUXEnCg4CU_djloEhEQmAUxva7490fhuqSyEbdOr6klpfvLGwRGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeehgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vBzUXAebj76TI0RrVzyFxee6ZiW6qi-CJOlNB93onbtsiHsf65cIcw>
    <xmx:vBzUXJCxAcn-tlz0EPv7Q3lGEByxUOOemakgP-A1Ox8sOBHlHOYosA>
    <xmx:vBzUXKeQjYkApaTwM0ZZciaDNzYoFDu4SB8khoU1geQRdlrcCWr5Lw>
    <xmx:vRzUXFOWob2iFe2RERNnXjS6IKY7bTia7VPhIg8zoF3DwPtnynVfUA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28EDD10378;
        Thu,  9 May 2019 08:27:40 -0400 (EDT)
Date:   Thu, 9 May 2019 14:27:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.41-rc1-721c545.cki (stable)
Message-ID: <20190509122738.GB31542@kroah.com>
References: <cki.D9C3C37075.4ZHPVBFDGL@redhat.com>
 <20190509065118.GB3255@kroah.com>
 <2e54d4c4-362d-bf66-6c03-e81acfae5ad0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e54d4c4-362d-bf66-6c03-e81acfae5ad0@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 07:12:55AM -0500, Major Hayden wrote:
> On 5/9/19 1:51 AM, Greg KH wrote:
> > Here you are testing the linux-stable-rc.git tree, not the
> > linux-stable.git tree, like you do for the 5.0 queue.
> > 
> > Any reason why?
> 
> We're doing two types of tests right now on stable:
> 
>   1) Tests against -rc releases that appear in linux-stable-rc
>   2) Tests against stable-queue patch lists (we apply them to the latest release in linux-stable)
> 
> Should we adjust our testing approach?

Ah, no, I was just confused in that the 5.0 responses seemed to be
against the stable queue and the 4.19 only against the -rc tree.
Please, testing both would be great!

I'll wait for you all to get the configurations all set up before making
any more stupid assumptions :)

thanks,

greg k-h
