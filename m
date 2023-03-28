Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642C96CBBE7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjC1KH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjC1KHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 06:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662D7EFA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 03:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE280B81BE0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 10:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835D5C43445;
        Tue, 28 Mar 2023 10:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679998039;
        bh=wyAv9eRAXALJ+L7YkXSDjdCNq/7aAeurCZN9GFbcPE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=scWda+7HJYd38FDIKG9bpbClJ7sgz0zbRlfGbSjP9g+NVGbczMt/o0O3EMURjwy6+
         P7VF0xy0gReSDg35NDYon4JwZjh6s9lRid1L0UT3P6yc8JmpuXp6cXXn7ZjplKw0vJ
         3HNiABMzq7U+QYvTXtLN795jE0DLYMATzrlZRX+cICjCknv98aktOT8sdvBY/c2h+G
         nRH3h7Zv1R4n6D72Y/3K8g3Z0QRJmGPkY1Z1jWAc6HZMVwM4a+tjcciasnucFpjjJG
         LExRb+0NLNe7rlw+40r5I05H/NEO58Q6qUCVLBU9Zfs/9Op05bcN/n4tw66+TWVuOZ
         Lkttb6kkG/ADw==
Date:   Tue, 28 Mar 2023 06:07:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: 6.1 Backport Request: act_mirred: use the backlog for nested
 calls to mirred ingress
Message-ID: <ZCK8Voa2AWbCUHo6@sashalap>
References: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 27, 2023 at 01:15:45PM -0700, Nobel Barakat wrote:
>SUBJECT: act_mirred: use the backlog for nested calls to mirred ingress
>COMMIT: commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640
>
>Reason for request:
>The commit above resolves CVE-2022-4269.

Queued up, thanks.

-- 
Thanks,
Sasha
