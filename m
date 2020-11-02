Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0752A2A9E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgKBMXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbgKBMXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 07:23:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA4B2231B;
        Mon,  2 Nov 2020 12:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604319785;
        bh=z2WjWc27IxBvWbavb5lH9toier6laVxYpERK0bGy24Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Brqnu0g3AFAckE6UqVGI0npYe7fXdxa92yuRH3Fvnth9vbgdl6CnXiLOybRAu3RLK
         TFq3maRyDSVyPjo+mtQz9inTNM5mLQc3qJOybQHUpLH0DLjwK6hhtXg/L+ELTx73EQ
         6LKVzfgId65mMkdD0diGZ9LvpKoAleU8RERSoGzQ=
Date:   Mon, 2 Nov 2020 13:24:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please add XSA fixes to stable branches 5.8 and 5.9
Message-ID: <20201102122400.GA666046@kroah.com>
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

Sorry, I am still 271 patches behind in those that were marked cc:
stable to be queued up yet.  The influx of patches during the -rc1 merge
window that are cc: stable is, frankly, crazy.  If these were so
important to be merged into 5.9.1, why didn't they get into 5.9.0?

Anyway, I'll work on these over the next few days, thanks...

greg k-h
