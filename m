Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D0290C32
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393102AbgJPTWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:22:52 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:11792 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391431AbgJPTWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602876172; x=1634412172;
  h=from:to:subject:date:message-id:mime-version;
  bh=eOO+uiMOArEmzXKk3CQSFfca5OToVSD2nODS+8S4R+M=;
  b=NyaZliVHf//3MpuluaklecK5pCMALUF6yVs964rFLdv3eY3GQEZk7fAG
   qVQSLR78Zkuv1o9GMMttKQPE9m5aNVacUOkT53/STPBXjA8Jj3WbH2HFL
   HHNqDqo3IlKFK7kYDlg1xwnehEzS8sBmJsMse8W9042Fu/3iL27mBjTw8
   k=;
X-IronPort-AV: E=Sophos;i="5.77,383,1596499200"; 
   d="scan'208";a="85394995"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Oct 2020 19:22:33 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 4394DA1DAF
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 19:22:32 +0000 (UTC)
Received: from EX13D37UEA004.ant.amazon.com (10.43.61.245) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 16 Oct 2020 19:22:32 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D37UEA004.ant.amazon.com (10.43.61.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 16 Oct 2020 19:22:32 +0000
Received: from dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (10.1.57.236)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 19:22:32 +0000
Received: by dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (Postfix, from userid 5360108)
        id 48216BE25F; Fri, 16 Oct 2020 19:22:32 +0000 (UTC)
From:   Boris Protopopov <pboris@amazon.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Date:   Fri, 16 Oct 2020 19:22:22 +0000
Message-ID: <20201016192223.31229-1-pboris@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Please include in multiple versions
