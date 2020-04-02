Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407F019C9ED
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgDBTU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389261AbgDBTU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 15:20:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208E8206F8;
        Thu,  2 Apr 2020 19:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585855255;
        bh=mdROf5FDATZ7QP97pw47LQyxagMXuoP+y7Kaxh6NErM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+rTAt0fHo/krTsbIxVlaFbiH3a630gdyVE6f4HA6qC54/KKEwURGtEMnU21vWygR
         del+6EMtTZ+Amw3nflUoCTHRWjiIMsiCrNwu5XGTQ7OZZrkstHbAga8OmPyLZDuO81
         LI0QpDjAFcnNDavJEKpe0aDJIDhmaJl9549G/Kyw=
Date:   Thu, 2 Apr 2020 21:20:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 4.19 105/116] bpf: Explicitly memset the bpf_attr
 structure
Message-ID: <20200402192053.GB3243295@kroah.com>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161555.630698707@linuxfoundation.org>
 <20200402185320.GA8077@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402185320.GA8077@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 08:53:21PM +0200, Pavel Machek wrote:
> Should we fix gcc, instead?

Also, this is allowed in the C standard, and both clang and gcc
sometimes emit code that does not clear padding in structures.  Changing
the compiler to not do this would be wonderful, but we still have to
live with this for the next 10 years as those older compilers age-out.

sorry,

greg k-h
