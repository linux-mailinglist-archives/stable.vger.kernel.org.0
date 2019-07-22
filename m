Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EF2708CF
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 20:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbfGVSlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 14:41:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:38844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbfGVSlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 14:41:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 777E7AF39
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 18:41:20 +0000 (UTC)
To:     stable <stable@vger.kernel.org>
From:   Juergen Gross <jgross@suse.com>
Subject: Patch for stable kernel
Message-ID: <56dfd6e8-06f7-bdcb-f88d-e7fc102127e0@suse.com>
Date:   Mon, 22 Jul 2019 20:41:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply commit a1078e821b605813 ("xen: let
alloc_xenballooned_pages() fail if not enough memory free")
to the stable kernel tree.

It is mitigating a security bug related to Xen (XSA-300).


Juergen
