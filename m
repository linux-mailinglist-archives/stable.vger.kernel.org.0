Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969B024BEC2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHTNbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgHTNbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 09:31:43 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F87C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 06:31:43 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4BXQXm2B0lz9sV5; Thu, 20 Aug 2020 23:31:36 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>, stable@vger.kernel.org
In-Reply-To: <20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com>
References: <20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] powerpc/pseries: Do not initiate shutdown when system is running on UPS
Message-Id: <159793027467.2366922.12802265066694495629.b4-ty@ellerman.id.au>
Date:   Thu, 20 Aug 2020 23:31:36 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:48:44 +0530, Vasant Hegde wrote:
> As per PAPR we have to look for both EPOW sensor value and event modifier to
> identify type of event and take appropriate action.
> 
> Sensor value = 3 (EPOW_SYSTEM_SHUTDOWN) schedule system to be shutdown after
>                   OS defined delay (default 10 mins).
> 
> EPOW Event Modifier for sensor value = 3:
>    We have to initiate immediate shutdown for most of the event modifier except
>    value = 2 (system running on UPS).
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/pseries: Do not initiate shutdown when system is running on UPS
      https://git.kernel.org/powerpc/c/90a9b102eddf6a3f987d15f4454e26a2532c1c98

cheers
