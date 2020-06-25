Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA86209A20
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgFYGzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgFYGzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 02:55:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A5EE206FA;
        Thu, 25 Jun 2020 06:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593068149;
        bh=dKy7S12hrE9hFy+beecSnv3vuR1mevAYOGrNHJIrKoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PI7V5iRVHiDdmiCV/HJR7jWCxNPhSFsyDRE3GpDRWC4Bd05yG1Dz/d0+lXFw5wL0m
         bXLdcUaREyL0jUDyQtsizP8HlVKa+gx2kDhQ2sH6eHOdXr4+kxZJ4uOZksPBcIcHBW
         bmigJv3+BI0jp2q6vd81885iRnQAx6DunZ20huCE=
Date:   Thu, 25 Jun 2020 08:55:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 09/10] mfd: atmel-smc: Add missing colon(s) for 'conf'
 arguments
Message-ID: <20200625065545.GA2789306@kroah.com>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-10-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625064619.2775707-10-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 07:46:18AM +0100, Lee Jones wrote:
> Kerneldoc valication gets confused if syntax isn't "@.*: ".
> 
> Adding the missing colons squashes the following W=1 warnings:
> 
> drivers/mfd/atmel-smc.c:247: warning: Function parameter or member 'conf' not described in 'atmel_smc_cs_conf_apply'
> drivers/mfd/atmel-smc.c:268: warning: Function parameter or member 'conf' not described in 'atmel_hsmc_cs_conf_apply'

Why is this a stable patch?

