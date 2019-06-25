Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41E65216A
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfFYDx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:58 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51629 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbfFYDx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 23:53:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B5E3046E;
        Mon, 24 Jun 2019 23:53:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 24 Jun 2019 23:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=0p6XJ5WGHkb77/Mx0EFjQ4RB7EF
        feZHy7RkmhbsILws=; b=puOXqJYa1xtRlFUJN8JMcQtr54bk4zclgQbonpwzvqH
        rWw9UiK0jEVm8ihrXWb543Ezjw95T7OJt5Pq+YRAn+zSZ9a2ddUC4RM0uNqmy0cw
        e6TlNXymfmjQAtv5MiUBz2kmkoF0hZCDK7xmNTtx3RmxRqRH2m/oYRUGJrmkwX4w
        6+kq8hX8XAZ+FiNhQbr/XO5K7qiMbUYWRdV1VhnACo70YfqyZ61upeRMIrwvZO38
        pS27+oXP3BTMOzSyHnwaCcEM3Di6FW5PTl2Sm9GXL2/RDYWvpqFWJbnC4Dyo04HP
        /zT0Vdbnzzt7QE3SLLFfi/kLyHuiFgz/TAjCQ2LBwTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0p6XJ5
        WGHkb77/Mx0EFjQ4RB7EFfeZHy7RkmhbsILws=; b=mJByjwY/SjwFyq4boZACGk
        VYbufJfhJpzxcAhQF7ZtxKDmPMPQRbM/O+JJX8aNmQ7IQtvqQwFKJLXRzrQBCPZP
        QPtIKPpmjQlBNUVNETyZNTVRlEy+XYyEKcZVvFy95fBGnfGBUfZdpXlv4R/ttUXI
        Ae+iPJL2ChGxDvS8jErrDbhOdMo7CcuBqfQJKuoosqOPTzDfipM0ZvigvItlH2yM
        NLxfQYGAVAs3kUF1/+Mvp3ByimxhrIxZxJomePPGN1fCp7Ip8LBTJNoNIo0hQopL
        uoP9GeVf7arttdIeOqnsJFzXMACMxd/8eSXxAtBYhFTQM4ZA73AYwzt4mq4ar9qA
        ==
X-ME-Sender: <xms:1JoRXXCodKkDKZc7D9pvqvsij1ypte5efYQKVHVWPIlm4zjGhiycPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeduudeirddvvdeirddvgeelrddvuddvnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1JoRXZX3Bgqln6Mx_idIv79kQ6Xusl66F_Z_1JfrUx5CZAklznQTWA>
    <xmx:1JoRXZBsKhbpCfu0DCyxl527WP2dr4PjHvET5HxoJe_GpYLCcEaYdg>
    <xmx:1JoRXWeehBZgXU9R_1SYfh_-6chu3yY9PaqfpVEbNNhl5V8-7zKs-A>
    <xmx:1JoRXTwwzVA_A4_f6jA6gCTAdkMx_buOV40faSWqCJpaCSRv8uK5iA>
Received: from localhost (unknown [116.226.249.212])
        by mail.messagingengine.com (Postfix) with ESMTPA id 711B68005C;
        Mon, 24 Jun 2019 23:53:55 -0400 (EDT)
Date:   Tue, 25 Jun 2019 11:46:11 +0800
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190625034611.GA13030@kroah.com>
References: <cki.306A4B3CD6.JH478GOVMF@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.306A4B3CD6.JH478GOVMF@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 11:41:57PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: aec3002d07fd - Linux 4.19.56
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 

Again, your tools are wrong...
