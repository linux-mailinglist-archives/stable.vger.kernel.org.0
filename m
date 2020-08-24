Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF9D24F314
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHXHZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:25:37 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:49585 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgHXHZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 03:25:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2E38219413EA;
        Mon, 24 Aug 2020 03:25:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 03:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=g59pFV
        nchMjv0AEDnBURPSyoNeLkzYeLtaKY1aR1SvM=; b=j6XyzVJv/8dtdjxePFKg5N
        cUkGLks8RUasThTwm17DvW02DGLSVUK9JYQUUtIP1/qPfbiqqvNETFoZrR/ybtal
        L3hnIXowge74IdtSObJvfwn+zWDsgt+9kUE3EYOKbX0NxQTJqroiydtPc/cln7pN
        u9rkvoEaxpLzhRK4aVJVdqqxkld4V2HxoU6vSreph0X2vIyrH7UxWNPaWG9m7zSE
        U1S073YEv+XiHaYess8Tp4eo+XsR60hvkplLLsQCeeAosKg26xi3YAP57hdXQZvt
        fQQmQhT/q8Zd3j1QfS9gtm2OLGpk7SeM+dC2XrQSl5C/9vRxhvVPmSTfYhDJdeeg
        ==
X-ME-Sender: <xms:b2tDX4W6ku9V9ectb4nxHigriPID_uQO2HlQSva6Zsi5mnmy7HKNcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:b2tDX8kEn2Wei7bCWcqq4yaRJVm2QmFuAmtZ6jyw7SW7uU1TlzXlig>
    <xmx:b2tDX8b3rdHbzlIW8LnRBKDPWloxHBaafgeE43HAAezhXi50cX1znA>
    <xmx:b2tDX3XPGfeDVWjjNoNyLHC5Z46QapNI4rJHrdTy62-Pgg8MYT7jgg>
    <xmx:cGtDX8SnSdWyoGk6wOLDsazwKioDFStqxm16NX_csDx_SbVuo-4peA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5CA7328005D;
        Mon, 24 Aug 2020 03:25:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/pseries: Do not initiate shutdown when system is" failed to apply to 4.4-stable tree
To:     hegdevasant@linux.vnet.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Aug 2020 09:25:54 +0200
Message-ID: <15982539547011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90a9b102eddf6a3f987d15f4454e26a2532c1c98 Mon Sep 17 00:00:00 2001
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Date: Thu, 20 Aug 2020 11:48:44 +0530
Subject: [PATCH] powerpc/pseries: Do not initiate shutdown when system is
 running on UPS

As per PAPR we have to look for both EPOW sensor value and event
modifier to identify the type of event and take appropriate action.

In LoPAPR v1.1 section 10.2.2 includes table 136 "EPOW Action Codes":

  SYSTEM_SHUTDOWN 3

  The system must be shut down. An EPOW-aware OS logs the EPOW error
  log information, then schedules the system to be shut down to begin
  after an OS defined delay internal (default is 10 minutes.)

Then in section 10.3.2.2.8 there is table 146 "Platform Event Log
Format, Version 6, EPOW Section", which includes the "EPOW Event
Modifier":

  For EPOW sensor value = 3
  0x01 = Normal system shutdown with no additional delay
  0x02 = Loss of utility power, system is running on UPS/Battery
  0x03 = Loss of system critical functions, system should be shutdown
  0x04 = Ambient temperature too high
  All other values = reserved

We have a user space tool (rtas_errd) on LPAR to monitor for
EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
after predefined time. It also starts monitoring for any new EPOW
events. If it receives "Power restored" event before predefined time
it will cancel the shutdown. Otherwise after predefined time it will
shutdown the system.

Commit 79872e35469b ("powerpc/pseries: All events of
EPOW_SYSTEM_SHUTDOWN must initiate shutdown") changed our handling of
the "on UPS/Battery" case, to immediately shutdown the system. This
breaks existing setups that rely on the userspace tool to delay
shutdown and let the system run on the UPS.

Fixes: 79872e35469b ("powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown")
Cc: stable@vger.kernel.org # v4.0+
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
[mpe: Massage change log and add PAPR references]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index f3736fcd98fc..13c86a292c6d 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -184,7 +184,6 @@ static void handle_system_shutdown(char event_modifier)
 	case EPOW_SHUTDOWN_ON_UPS:
 		pr_emerg("Loss of system power detected. System is running on"
 			 " UPS/battery. Check RTAS error log for details\n");
-		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:

