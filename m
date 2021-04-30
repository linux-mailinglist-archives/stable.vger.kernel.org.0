Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172173700B4
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhD3SrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:47:13 -0400
Received: from mail1.bemta23.messagelabs.com ([67.219.246.115]:30179 "EHLO
        mail1.bemta23.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhD3SrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 14:47:13 -0400
Received: from [100.112.6.224] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-c.us-east-1.aws.symcld.net id 8D/C7-57782-0805C806; Fri, 30 Apr 2021 18:46:24 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRWlGSWpSXmKPExsWSLveKTbchoCf
  B4O8jTosFGx8xOjB6fN4kF8AYxZqZl5RfkcCa0TJZt2Aye8Xz1R1sDYyNbF2MXBxCAnOYJF61
  TWKBcJ4zStx/38bYxcjJwSagLbFlyy82EFtYIE1iZudGdhBbREBGYnrrXiYQm1fAVuJ253GwO
  IuAqsSSqVvB6kUFwiV2d7yEqhGUODnzCdACDg5mAU2J9bv0QcLMAuISt57MZ4Kw5SW2v53DDG
  JLANlPX/ewQdgJEj3/HrFNYOSbhWTSLIRJs5BMmoVk0gJGllWMZklFmekZJbmJmTm6hgYGuoa
  GRrpmukYGJnqJVbrJeqXFuqmJxSW6hnqJ5cV6xZW5yTkpenmpJZsYgcGZUsB2Zgfj9jcf9A4x
  SnIwKYnyvv/UnSDEl5SfUpmRWJwRX1Sak1p8iFGGg0NJgvedf0+CkGBRanpqRVpmDjBSYNISH
  DxKIrwn/YDSvMUFibnFmekQqVOMuhwnVy1ZxCzEkpeflyolzmsFMkMApCijNA9uBCxqLzHKSg
  nzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5l0KMoUnM68EbtMroCOYgI6oPNIFckRJIkJKqoEpI0e
  Qd/a/21bTQtw+5tb83/g5hkt0RUqhncX/u3kWV9J6i9wYrpcevMJmcGib9Se34oVJ0nyGqxxq
  FMJvT6lb13CB6e1aXv9M+4bVx4773lxXcmrN3DqF0mVvDGKOxa5l7Pda5b1EKfakpcEFHv+3E
  mI3Ofr4ggMF5QU76r7cNVh90PXoHqX8sGVHF1z17u8rXqBw7Bhb7t3CWul9YbI2W47ul2ZNYL
  NREXKZq1s5rbx1VcMSUckKQ38TD8sYif019090fVovbTOXOfn9K5kF95ZUBE0xsD1WcHDqfo6
  KpYuyC+w/PxXMOXDo/N7vAVru0U91b58sX6Mu/PzsN7tZJe2sSZv31cjcKLaqs1ZiKc5INNRi
  LipOBABr/GcrVQMAAA==
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-35.tower-415.messagelabs.com!1619808382!15176!1
X-Originating-IP: [103.30.234.6]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.75.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1642 invoked from network); 30 Apr 2021 18:46:23 -0000
Received: from unknown (HELO lenovo.com) (103.30.234.6)
  by server-35.tower-415.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Apr 2021 18:46:23 -0000
Received: from reswpmail01.lenovo.com (unknown [10.62.32.20])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by Forcepoint Email with ESMTPS id A937CC87DEC1238A19A5
        for <stable@vger.kernel.org>; Sat,  1 May 2021 02:46:21 +0800 (CST)
Received: from localhost.localdomain (10.38.109.5) by reswpmail01.lenovo.com
 (10.62.32.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2176.2; Fri, 30 Apr
 2021 14:46:19 -0400
From:   Mark Pearson <markpearson@lenovo.com>
Subject: stable tree request - [PATCH] platform/x86: thinkpad_acpi: Correct
 thermal sensor allocation
To:     <stable@vger.kernel.org>
Message-ID: <ea996e9f-3727-fdb9-3c04-53898fa7655c@lenovo.com>
Date:   Fri, 30 Apr 2021 14:46:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.38.109.5]
X-ClientProxiedBy: reswpmail04.lenovo.com (10.62.32.23) To
 reswpmail01.lenovo.com (10.62.32.20)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi maintainer,

I'm fairly new to contributing to the kernel and didn't know about the
stable tree procedure so missed setting the CC:stable@vger.kernel.org in
my patch submission; I'm following option 2 on the stable-kernel-rules
guide.

Subject: [PATCH] platform/x86: thinkpad_acpi: Correct thermal sensor
allocation

Upstream Commit ID: 6759e18e5cd8745a5dfc5726e4a3db5281ec1639

Reason: Some EC registers on Thinkpad machines were being incorrectly
used as temperature sensors. One in particular was fooling thermald into
thinking the system was hot when it wasn't, and keeping fans ramped up
unnecessarily.

I've been requested by some distro's to get this fix into the stable
tree to make it easier for them to then pull into their releases.
If it's possible to add this to 5.11 and maybe 5.10 that would be
appreciated.

Please let me know if you need anything or have any questions

Many thanks
Mark Pearson
