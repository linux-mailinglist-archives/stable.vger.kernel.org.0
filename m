Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F33D8CCD
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbhG1Lcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:32:41 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37575 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236108AbhG1Lcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 07:32:41 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D415461E5FE00;
        Wed, 28 Jul 2021 13:32:38 +0200 (CEST)
To:     stable@vger.kernel.org
Cc:     Guohan Lu <lguohan@gmail.com>,
        Madhava Reddy Siddareddygari <msiddare@cisco.com>,
        Venkat Garigipati <venkatg@cisco.com>,
        Billie Alsup <balsup@cisco.com>,
        Ruslan Babayev <ruslan@babayev.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Backport commit a2d2010d95cd (iio: dac: ds4422/ds4424 drop of_node
 check) to Linux 4.19
Message-ID: <7388a1e0-c0bf-86b0-bcca-319ab8ca6048@molgen.mpg.de>
Date:   Wed, 28 Jul 2021 13:32:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linux folks,


Could you please backport commit 
a2d2010d95cd7ffe3773aba6eaee35d54e332c25 (iio: dac: ds4422/ds4424 drop 
of_node check) to Linux 4.19? It’s needed for Cisco switches [1].


Kind regards,

Paul


[1]: https://github.com/Azure/sonic-linux-kernel/pull/226
