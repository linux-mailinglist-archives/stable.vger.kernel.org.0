Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3D20A860
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 00:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404273AbgFYWrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 18:47:49 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:64029 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgFYWrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 18:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593125268; x=1624661268;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=atDwhsnKmJ8/qJk+d22DTqJthiMJwKfDIdZ9j4BfEuI=;
  b=adYzO2FqqwOBAU4Aifh014k5ct8sSxZLLZcKX0IzC421Y8JGnSXv5b6D
   zJYvVMA6waSCtKRk19T7xa/eAePKMNn2hyDZgyHlNw2WZZzC4NKdeIjYH
   P1XqiGdKOyvexYsw0RJDvUT9DlH+eyu9IeIfxrhCZw0SElgcTBT7mAXuI
   g=;
IronPort-SDR: aeas2eoJJRIhfCf1MbuwfBK+CUJx7rotMNue/ro9qatvhkfZ79MXslegWiWEV/qteTrtPQpBQX
 rqh5dMZNvzLA==
X-IronPort-AV: E=Sophos;i="5.75,280,1589241600"; 
   d="scan'208";a="39924235"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 25 Jun 2020 22:47:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 006C1A17FB;
        Thu, 25 Jun 2020 22:47:46 +0000 (UTC)
Received: from EX13D25UEA003.ant.amazon.com (10.43.61.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 22:47:46 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D25UEA003.ant.amazon.com (10.43.61.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 22:47:46 +0000
Received: from dev-dsk-yishache-2a-0a3e7335.us-west-2.amazon.com
 (172.19.44.166) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 22:47:46
 +0000
From:   <yishache@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
Subject: Request for inclusion on linux-4.14.y and linux-5.4.y
Date:   Thu, 25 Jun 2020 22:47:27 +0000
Message-ID: <20200625224728.15305-1-yishache@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patch in the stable linux-4.14.y branch?

This is to fix CVE-2020-12655

d0c7feaf87678371c2c09b3709400be416b2dc62(xfs: add agf freeblocks verify in xfs_agf_verify)

Thanks,
Yishan Chen
