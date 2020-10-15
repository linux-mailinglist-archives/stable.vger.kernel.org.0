Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE328EB43
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 04:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgJOChd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 22:37:33 -0400
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:44118 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387703AbgJOChd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 22:37:33 -0400
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 09F2X1cH028628;
        Wed, 14 Oct 2020 19:37:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=kUj+D9OG6rY4+uTxt2+VvemSnMsboxNG9U7VkppOdOM=;
 b=lMa7XmkuekZPf4FQ//63tUUPnb6fREIygitYuZuGqP/OUJwxTy6nWFHv/M6ZyqitnRnn
 bMhLbMMhJTnRuoaOTCqkxM8jSHl3QGASZK8MCaK5wbMs7M+CWsxfm/wYPF28wHB/y142
 sMnLpChJJU3rGXIt/f2QI9qPf3Uct7k6PwAh8tZbMg04UJwA3RJGfn71X2jW2f/DiJOm
 0+Vtt5Vxq/whbqb0GOh+x8g6ugN+9bkfnsSRcxOnhLMHw/7BFHxzZfMc9q0iuXUUd3UT
 0G3IUeLsjv/cpWbtmZhX+Cu4Ta+n85iTl4UNubR/UzEg6ogiqarZnwhhORehZ5KS2ECk rw== 
Received: from rn-mailsvcp-mta-lapp03.rno.apple.com (rn-mailsvcp-mta-lapp03.rno.apple.com [10.225.203.151])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 3439mudq77-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 14 Oct 2020 19:37:24 -0700
Received: from rn-mailsvcp-mmp-lapp03.rno.apple.com
 (rn-mailsvcp-mmp-lapp03.rno.apple.com [17.179.253.16])
 by rn-mailsvcp-mta-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) with ESMTPS id <0QI800W3O1YBKW10@rn-mailsvcp-mta-lapp03.rno.apple.com>;
 Wed, 14 Oct 2020 19:37:23 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp03.rno.apple.com by
 rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QI800S001NF8W00@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Wed,
 14 Oct 2020 19:37:23 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 3a9d82d30857ca08436fbabda4f0d128
X-Va-E-CD: 5c5b7582969293fb57a13fea63578bea
X-Va-R-CD: 44c82d96f2bad333b59571b5ab51af9b
X-Va-CD: 0
X-Va-ID: b07062a3-90d7-4502-bcde-57c64ab09277
X-V-A:  
X-V-T-CD: 3a9d82d30857ca08436fbabda4f0d128
X-V-E-CD: 5c5b7582969293fb57a13fea63578bea
X-V-R-CD: 44c82d96f2bad333b59571b5ab51af9b
X-V-CD: 0
X-V-ID: 901e2c3a-2c88-4b5e-8661-0a58f2cfd477
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_01:2020-10-14,2020-10-15 signatures=0
Received: from Vishnus-MacBook-Pro.local (unknown [17.149.214.245])
 by rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QI800SC61YA9J00@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Wed,
 14 Oct 2020 19:37:23 -0700 (PDT)
From:   Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: acpi ged fix backport to 5.4 stable
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Forgue <andrewf@apple.com>
Message-id: <74cde3d0-11fc-43fa-aaaf-ec61fd6ec318@apple.com>
Date:   Wed, 14 Oct 2020 19:37:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-GB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_01:2020-10-14,2020-10-15 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can we have this backport applied to 5.4 stable, its a useful fix for 
generic kernels compatibility.

commit ac36d37e943635fc072e9d4f47e40a48fbcdb3f0 upstream


