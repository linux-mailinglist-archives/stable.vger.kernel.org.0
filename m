Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18981291010
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 08:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437022AbgJQGT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 02:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411646AbgJQGT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 02:19:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5060520760;
        Sat, 17 Oct 2020 06:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602915597;
        bh=3kfKZiXBxzY5XlhQyZeT+IWIyF9ZbO6V4QcYG0IWj+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FZjzSHfGgw4Kqj5RutikpR+dvxWm4Qtf2C+7JCO3ndjvEDTnUc51my6p/iDv2AV0a
         ypbA74yv7lPEpO3UrYU/6GQUxmkpyy/8bq8dyFgRW+9B+lBOjfQeah1JJHR0oIjjBv
         ydC4dE/JV2uPDBGCH+ihSGc7N8ikYpMHjRsr3ENg=
Date:   Sat, 17 Oct 2020 08:20:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Boris Protopopov <pboris@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9-5.8] Convert trailing spaces and periods in path
 components
Message-ID: <20201017062026.GA1880265@kroah.com>
References: <20201016192223.31229-1-pboris@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016192223.31229-1-pboris@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 07:22:22PM +0000, Boris Protopopov wrote:
> 
> Please include in multiple versions

Include what???
