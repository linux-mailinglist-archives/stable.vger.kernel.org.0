Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39D2A2E90
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKBPpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgKBPpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 10:45:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 774DE22275;
        Mon,  2 Nov 2020 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604331909;
        bh=NHBoMt9UTVGy1kD3jge9XPqP7VCl7znpnAomLOCjr9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tq9sxXmINPupSZX/kWYJMqz6Fj+jYL8qus0mHqRq4h9aWqUULMT1PHHupeXdya6JU
         yaRnOX0D8F608G0BdlQx8k3obZ9rlV5mkP4ZHkNn7Fx1TnXivMzZLeN34KleknN1Ft
         4mSeF6imyYH+qoPA+Et1DN+/mAM5t2OatLRrpQmA=
Date:   Mon, 2 Nov 2020 16:46:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please add XSA fixes to stable branches 5.8 and 5.9
Message-ID: <20201102154604.GA1488920@kroah.com>
References: <3c023ab7-5daf-da7b-4b3b-66c0c2e6a97c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c023ab7-5daf-da7b-4b3b-66c0c2e6a97c@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 07:43:35AM +0100, Jürgen Groß wrote:
> Hi Greg,
> 
> even while tagged with "Cc: stable@vger.kernel.org" you didn't take
> some upstream patches from 5.10-rc1 for the recent 5.8 and 5.9 stable
> branches:
> 
> 073d0552ead5bfc7a3a9c01de590e924f11b5dd2
> 4d3fe31bd993ef504350989786858aefdb877daa
> f01337197419b7e8a492e83089552b77d3b5fb90
> 54c9de89895e0a36047fcc4ae754ea5b8655fb9d
> 01263a1fabe30b4d542f34c7e2364a22587ddaf2
> 23025393dbeb3b8b3b60ebfa724cdae384992e27
> 86991b6e7ea6c613b7692f65106076943449b6b7
> c8d647a326f06a39a8e5f0f1af946eacfa1835f8
> c2711441bc961b37bba0615dd7135857d189035f
> c44b849cee8c3ac587da3b0980e01f77500d158c
> 7beb290caa2adb0a399e735a1e175db9aae0523a
> e99502f76271d6bc4e374fe368c50c67a1fd3070
> 5f7f77400ab5b357b5fdb7122c3442239672186c
> 
> Could you please add them? They are fixing some security issues. I have
> tested them to apply cleanly.
> 
> For the older stable branches I'll supply backports.

5.8 is now end-of-life, but I've added these all to 5.9.y now, thanks.

greg k-h
