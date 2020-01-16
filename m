Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DD113FD3B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391037AbgAPXXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgAPXXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205502077C;
        Thu, 16 Jan 2020 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217010;
        bh=80qMqilDKb1q7yzrUTzmSO/ts7DiRjQ2oLgmnoGIPT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmXa+j9WwSK3lthvk84nX+swdJdwR494eBOpEqfz6aKpM2zCNwukHLtDYRvhygsK0
         mfFgHbWB1gsx4AfZ9dKu99YZqcn6lSM3+PgS1CU3nWhq1PYZ3d9ygq+rUK8Ou8FIAA
         ZF1JfLqH19cS1mPSR4zgdXECDeRIM8y+63U3UsHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.4 111/203] mei: fix modalias documentation
Date:   Fri, 17 Jan 2020 00:17:08 +0100
Message-Id: <20200116231755.180550968@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 73668309215285366c433489de70d31362987be9 upstream.

mei client bus added the client protocol version to the device alias,
but ABI documentation was not updated.

Fixes: b26864cad1c9 (mei: bus: add client protocol version to the device alias)
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191008005735.12707-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/ABI/testing/sysfs-bus-mei |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-bus-mei
+++ b/Documentation/ABI/testing/sysfs-bus-mei
@@ -4,7 +4,7 @@ KernelVersion:	3.10
 Contact:	Samuel Ortiz <sameo@linux.intel.com>
 		linux-mei@linux.intel.com
 Description:	Stores the same MODALIAS value emitted by uevent
-		Format: mei:<mei device name>:<device uuid>:
+		Format: mei:<mei device name>:<device uuid>:<protocol version>
 
 What:		/sys/bus/mei/devices/.../name
 Date:		May 2015


