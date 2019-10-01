Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FFAC37B4
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbfJAOkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389200AbfJAOko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 10:40:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFC82054F;
        Tue,  1 Oct 2019 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569940844;
        bh=HTwHAXFxL+Tx4f6COLLwSU6ZTeaJ76Tm2LPUb7KU7YQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ndz4dUbKHy5gqhdlqfee2zjgiMwMeMItRPS7prx29YOGZKqmDSib8fTHdE8LSJA5a
         IA80V0wMZ5h4XYYc+NoLqVtoJThca3mIJ83cekMTnBc+0bBvg8yVR6E96sOQXrssOF
         P7hRQ2P1a8YXv+BWVDSzUEZq3QOaPbNlrRrpVtmg=
Date:   Tue, 1 Oct 2019 16:40:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: logicpd-torpedo-baseboard: Fix missing video
Message-ID: <20191001144041.GA3294715@kroah.com>
References: <CAHCN7xL2f2R2KjPddZmmoBLSx_tkbNZ6R2tJ-j6tYmvLd856AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xL2f2R2KjPddZmmoBLSx_tkbNZ6R2tJ-j6tYmvLd856AA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 08:26:26AM -0500, Adam Ford wrote:
> Please apply f9f5518a3868 ("ARM: dts: logicpd-torpedo-baseboard: Fix
> missing video") to 5.2 and 5.3 stable branches.
> 
> This fixes an issue where video is lost due to the removal of a driver
> and its replacement was not enabled.

Now queued up, thanks.

greg k-h
