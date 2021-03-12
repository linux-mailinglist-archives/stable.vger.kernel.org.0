Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09003393F3
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhCLQx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:53:59 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44195 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232238AbhCLQxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 11:53:54 -0500
Received: from [192.168.0.7] (ip5f5aeac2.dynamic.kabel-deutschland.de [95.90.234.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 44C8E206446A2;
        Fri, 12 Mar 2021 17:53:50 +0100 (CET)
Subject: hwmon: (lm90) Fix max6658 sporadic wrong temperature reading
To:     stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org,
        Guohan Lu <lguohan@gmail.com>, Boyang Yu <byu@arista.com>,
        Guenter Roeck <linux@roeck-us.net>
References: <20210304153832.19275-1-pmenzel@molgen.mpg.de>
 <20210311221556.GA38026@roeck-us.net>
 <9243482c-0a34-d6d1-1955-bee00a75554f@molgen.mpg.de>
 <d4756f39-3a4b-7348-c49b-25701e31f99b@roeck-us.net>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <02b9c3fe-5961-6a23-3fd0-6d7687867fb1@molgen.mpg.de>
Date:   Fri, 12 Mar 2021 17:53:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d4756f39-3a4b-7348-c49b-25701e31f99b@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linux folks,


Could you please apply commit 62456189f3292c62f87aef363f204886dc1d4b48 
to the Linux 4.19 stable series?


Kind regards,

Paul
