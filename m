Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C15F642B82
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiLEPUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 10:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiLEPT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 10:19:29 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D00A17887
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 07:19:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so15133822pje.5
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 07:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itK0lGrBrasi0LjGNM6JVFc4KHz+RlxvLLTnPjfvfU0=;
        b=Tkf3245XxyLRPgf8tcTbRBy3FfNc00nvLO1WPU1S5VBIHPzEaaKfQi9kSHMfuyegC9
         0nJE+qoaDaGwbXXBhkE6g05SjYwnxL7pzU6htGaiQjIbBINNtO8yPHtIBgrXRDalSLsB
         FRItM0IO8my8WOYODXQE0c7zXqSfpSL4Fs+b9FSmr1uWmbxKjlm/cTEH3jK7p2v89I0J
         atWTlqa88aBU5HQEquj/1+b2tHqN7JCymE9bbgVewzN1plCc45//O7zvRdLPFO3Rme2s
         XeJW9jJ8lNGwKvIPqLVj0WPxugkSz7xfWgGOPjdP0Ci57rfsBjiMJoJ/f3VW6xrmAWNQ
         O+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itK0lGrBrasi0LjGNM6JVFc4KHz+RlxvLLTnPjfvfU0=;
        b=EAot4TpX4hUa9i1YvXc1F2AJnjel7p6RPMgwVZuJPRuQnYZdEuxbXJhpJ/UQ7i07dC
         A9vbq/jxD+PkbuD8QZzMCjp9pvv69VxzL75IQOdqET+yFhOTXkLkN97O474/wJBRwjjz
         m0RIOYLYyB09+vbZ1VRdsKpL0d+kh5DZoxr6xNpx2HANYwRzqaerJiuJfhyd6XiqXuwG
         KWjI/WaiTJE+Ensbhzm+GYpASQHCg+jII9IGPhvIjzG6U/QopJcAIjeodOSPsSrNJPpJ
         zrdlTvLPI27YDBfn2FcyfclQJh/yLRJwB3ny0vk+xlP4G6vIJ01S5wI90zr++LSqrjvg
         VwNA==
X-Gm-Message-State: ANoB5plEHgy4t4xzzDc7XdL9vOTgOlV3krdOZPKQ0qUaVo3FD7daxWRj
        OaQ0kAHY1UQt9A0BROji32ctZ8BTlqzMrhRbfqI=
X-Google-Smtp-Source: AA0mqf4qQVVA6sKuGVfhNEDxIKEJ4wb+2Mrn5ozcDW8WegYpNnzxJjMAR3mm/1hrG6QlWGLxQt5YzQ==
X-Received: by 2002:a17:902:e0cd:b0:189:b0a3:cf49 with SMTP id e13-20020a170902e0cd00b00189b0a3cf49mr22602729pla.77.1670253565444;
        Mon, 05 Dec 2022 07:19:25 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y69-20020a62ce48000000b00571bdf45888sm6465297pfg.154.2022.12.05.07.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 07:19:25 -0800 (PST)
Message-ID: <50de97fe-43f1-188f-511a-f29611944ce7@kernel.dk>
Date:   Mon, 5 Dec 2022 08:19:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5.10.y stable v2] block: unhash blkdev part inode when the
 part is deleted
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        Shiwei Cui <cuishw@inspur.com>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
References: <20221205132739.844399-1-ming.lei@redhat.com>
 <Y44JWBw9opr2HVyN@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y44JWBw9opr2HVyN@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 8:08 AM, Greg Kroah-Hartman wrote:
> On Mon, Dec 05, 2022 at 09:27:39PM +0800, Ming Lei wrote:
>> v5.11 changes the blkdev lookup mechanism completely since commit
>> 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
>> and small part of the change is to unhash part bdev inode when
>> deleting partition. Turns out this kind of change does fix one
>> nasty issue in case of BLOCK_EXT_MAJOR:
>>
>> 1) when one partition is deleted & closed, disk_put_part() is always
>> called before bdput(bdev), see blkdev_put(); so the part's devt can
>> be freed & re-used before the inode is dropped
>>
>> 2) then new partition with same devt can be created just before the
>> inode in 1) is dropped, then the old inode/bdev structurein 1) is
>> re-used for this new partition, this way causes use-after-free and
>> kernel panic.
>>
>> It isn't possible to backport the whole big patchset of "merge struct
>> block_device and struct hd_struct v4" for addressing this issue.
>>
>> https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/
>>
>> So fixes it by unhashing part bdev in delete_partition(), and this way
>> is actually aligned with v5.11+'s behavior.
>>
>> Reported-by: Shiwei Cui <cuishw@inspur.com>
>> Tested-by: Shiwei Cui <cuishw@inspur.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Jan Kara <jack@suse.cz>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V2:
>> 	- fix one typo and Shiwei's email format
>>
>>  block/partitions/core.c | 7 +++++++
> 
> I need an ack from the block maintainers/developers to be able to take
> this.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


