Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022A7343C27
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhCVI4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:56:12 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42843 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhCVIzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:55:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D1EA11595;
        Mon, 22 Mar 2021 04:55:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 04:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=6hH5Sa7sZWXWLQlKm5y6yCYykII
        ttd7AHRumiEwxhT4=; b=RJxXjbFVSy2WFzuRaDRBIw9H61mB17dDCDWPFawu9GT
        wL5nUquJfPYF9FpF7v61//W/S5B66VDM0xiwnBiR2xUYgTAltEqViQF62hqL5V3/
        xp3oVRRrTnQd8hcfCLiOXahpTEGK2Lx7JTCPyT473EzzKX3zO4/SvHGufDRK+Y9W
        oLv8hd1yvvzbulb5gdn8wnGaHBLv9sLS7Kti2C4Gw1DoCMoLvZdYsf4+9WbknVXi
        a8J6cZou+A7V3BL1tFE00CrI2A4k/yPDR+u+cckFYRCEClHCjUHn10QXQTY9R93G
        WwQj/VLJ5e812yDrR2clRdL6jnA++3y03NsjLcX+Mcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6hH5Sa
        7sZWXWLQlKm5y6yCYykIIttd7AHRumiEwxhT4=; b=HiB9zI1u8tcUc6D70fvqZj
        yBZmYIIVy+6AK/j7mhR8RjqWOcdHbJ5B4mlcR9UWA5H9Fh3LWwXHOSoji4RDg11K
        F58McqmcW4+u2u7Nz5DQBpfDNyzAfnjLUVUpnQ/JHsy0myf7+HW2aJjR264gmaAw
        xJVOqdtYqr6DJbah0nH2TP9rih1FlnIKh7uJ0RTjQP0sEAHEmGX9hN/5Lb2TvU6T
        UPifloV1IrcEniGbluRINcCzFpwm4Oln1BDwi7JTRQhdbKWMZlOBC8QGUZLj9aAw
        NJaPlGERowyS1IkB3IvSMkO6/cVMYbXyFmaSSaOrZhK8qt0vQ/YPeob4+JZLA9Qw
        ==
X-ME-Sender: <xms:i1tYYLSu-8oGiqhopaoZv87oeLutEfiDTf_C2YQoYWRTO-BV5VNZ_g>
    <xme:i1tYYMw2BfobrnC3bslvi59dMAWLvuzGLuEJB6v5mWcOxv8dUQsC4XKfjrquexc-a
    C-R8bTor5ZN3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:i1tYYA3144ZXIeEvbJ5stryEVUwhLOSs5uXyfW2E9yb13275cITn_A>
    <xmx:i1tYYLBwGLBlXPRuf53EaDV85fsltqf7RVqa_jh2hNtSXb-CWpgb8g>
    <xmx:i1tYYEjfKa4tjcWXvvkbq6zmm-koXf3GxUMH1AZbP328UnFeAFN13w>
    <xmx:jFtYYAbi6pVLvvGi5B8wy1yR0iKtqZ4a_EKSTq_K8m3F3VGdhbBw_g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4BC7240425;
        Mon, 22 Mar 2021 04:55:39 -0400 (EDT)
Date:   Mon, 22 Mar 2021 09:55:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "module: merge repetitive strings in module_sig_check()"
 has been added to the 5.10-stable tree
Message-ID: <YFhbielSveq71/aX@kroah.com>
References: <20210322030544.97E2961930@mail.kernel.org>
 <775e4802-cfdd-e78e-c97b-abf36a49fb43@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775e4802-cfdd-e78e-c97b-abf36a49fb43@omprussia.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 11:31:55AM +0300, Sergey Shtylyov wrote:
> Hello!
> 
> On 22.03.2021 6:05, Sasha Levin wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      module: merge repetitive strings in module_sig_check()
> > 
> > to the 5.10-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       module-merge-repetitive-strings-in-module_sig_check.patch
> > and it can be found in the queue-5.10 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
>    Why add this patch to the -stable tree? It's just a cleanup...

Looks to be needed for  ec2a29593c83 ("module: harden ELF info handling")
