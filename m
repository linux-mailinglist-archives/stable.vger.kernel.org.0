Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8797941335C
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhIUMcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232712AbhIUMcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 08:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFAB610CA;
        Tue, 21 Sep 2021 12:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632227436;
        bh=h0x5u7y8O+wTKQryB4bVjrFtlZ6A7gO+4Dv32rXLmVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HFSvZyr/dqZJP9HmwHNhHX6jv4k4pObPN9ZUSJN+11t9Yl0bKICNbNVNKhLqDrTFq
         LZISCmROpDF7cPjF/3pj9b/mS5sboIRpafhpIum1jcw5ZAEoGnuc1M/LkIyMhnih8N
         Uwi+xm0KP7hVJVOi0d63SAxx+psssJyHf/+8DLV4=
Date:   Tue, 21 Sep 2021 14:30:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: 5.13,5.14 | ath11k/mhi regression: Wifi stops working
Message-ID: <YUnQaZj2/6t2xJIK@kroah.com>
References: <f759ec8e-cfcc-7f78-65c5-97ecc24aad17@manjaro.org>
 <YUnQAvKKI7d8escn@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YUnQAvKKI7d8escn@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 02:28:50PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 21, 2021 at 02:02:20PM +0200, Philip Müller wrote:
> > Hi Sasha, hi Greg,
> > 
> > may you guys take a look at this?
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=214455
> 
> Please do not point to random links, send us the needed information in
> email please.

Ok, I broke down and looked.  Should be resolved in the next 5.14
release that will be out in a day or so.

thanks,

greg k-h
