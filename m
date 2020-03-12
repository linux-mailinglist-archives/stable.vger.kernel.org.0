Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7099182973
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 08:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388048AbgCLHDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 03:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387845AbgCLHDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 03:03:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A19206B1;
        Thu, 12 Mar 2020 07:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583996596;
        bh=3lM75Zv/cw0v5iFvOZiwtQKslNMGShDEpx9EnSTkxYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u8cVfidFoRduuEBNjC6B1SQW6gru2hT2GRzZatGGLR6gyXTzvkwuZsynZIe5F1sPp
         juiwoF/hmR62PBTJ90q0DIYb3dbVXjmSgMqyi3B0/HKGU84kuqbh6ITTt4NNVHgmpz
         So/cKqyZ7VACjc/NNhgXkSe74FgIkn+T0bB6cCuw=
Date:   Thu, 12 Mar 2020 08:03:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.25-rc3 review
Message-ID: <20200312070314.GC4157582@kroah.com>
References: <20200311181527.313840393@linuxfoundation.org>
 <3b63c382-2d41-eefd-9497-c70bc63b62d5@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b63c382-2d41-eefd-9497-c70bc63b62d5@applied-asynchrony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 08:29:54PM +0100, Holger Hoffstätte wrote:
> On 3/11/20 7:18 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.25 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This now builds & works fine for me on several machines.
> Thank you!

Great!  Thanks a lot for the testing and letting me know.

greg k-h
