Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6125E3A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 08:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfEVGhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 02:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfEVGhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 02:37:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0831A2173C;
        Wed, 22 May 2019 06:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558507052;
        bh=Ne7MBZNHefjJFihtI9LoLR1nw0+6w9iEkYTdm2ZzUrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8mH+EZFLj8ShjbKD0c1MGlmmtsOT2cPuiEvZgEDKMM80tM2UFEnFOSo/VkPOuOFY
         VY0JW2btfJDfuEsSqPOjTA4hLvTz00T7VmS1Mis9dESTCYV9Yh+F9D+G9XFHiyeHZ0
         uzAYV9L1VepJPjIrkQ7YgTsOfmHJw9SokgAJObkE=
Date:   Wed, 22 May 2019 08:36:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190522063645.GA2637@kroah.com>
References: <20190520.233745.1944769860995696408.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520.233745.1944769860995696408.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 11:37:45PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.0 and v5.1
> -stable, respectively.

All now queued up, thanks!

greg k-h
