Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7428DA73CF
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfICTkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfICTkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:40:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7181A307D978;
        Tue,  3 Sep 2019 19:40:01 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-59.rdu2.redhat.com [10.10.120.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3048660606;
        Tue,  3 Sep 2019 19:39:58 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e2=2e11?=
 =?UTF-8?Q?-c3915fe=2ecki_=28stable=29?=
To:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
References: <cki.EDBAAD9BB8.PJ4CXK5IUR@redhat.com>
 <20190903062434.GD16647@kroah.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <98810f6d-3bff-61be-f6dd-d24902d497e3@redhat.com>
Date:   Tue, 3 Sep 2019 15:39:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190903062434.GD16647@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 03 Sep 2019 19:40:01 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The aarch64 system failed to boot the CKI kernel due to an infra 
failure, the xfs generic/114 test
could be an intermittent issue, I'll let Xiong confirm.

https://artifacts.cki-project.org/pipelines/140026/logs/ppc64le_host_1_xfstests_xfs_resultoutputfile.log

-Rachel

On 9/3/19 2:24 AM, Greg KH wrote:
> On Mon, Sep 02, 2019 at 10:38:46PM -0400, CKI Project wrote:
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>              Commit: c3915fe1bf12 - Linux 5.2.11
> Same git commit id fails one test run but passes another?  You all might
> want to look into this...
>

