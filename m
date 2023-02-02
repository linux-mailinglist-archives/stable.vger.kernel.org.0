Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C3D6886EF
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 19:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjBBSoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 13:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjBBSoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 13:44:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA6449F;
        Thu,  2 Feb 2023 10:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC9461743;
        Thu,  2 Feb 2023 18:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57999C433EF;
        Thu,  2 Feb 2023 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675363421;
        bh=7tBN3efqE0mc+ooc1QAXaZ3aYSIQ0nhfE6pP0qEvBOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEfFO8ohI8t4UTORuXvu8PC35Msdvbs8gmGzjzdbbs4MooF7NpyMIR1nvfiNn952E
         cD0ktwcugbRM2kaalWxE/I5/iC/G0Jw4mz1ppmLJNhpgBRk/mplwJbKaMCxsOmdU3J
         c+pjA8XYCyGVaemEZS/DwB32tYCPVl5p5dRRrThGVOJa8dF3IMI49EVEDwGsLR5Jtb
         Q1S1Dm4VBq84q58XDA7BRIx9kyfSebFwNUOyfPiuN0sbPQqcoaU6dPL57A0WdSWeT9
         y5STlL5OtK7z1pUUe3UxrYn56XffEkLcIWocc1xWW0czDZiOsuAwOudca1aDeaA8Ra
         wyEy/3d4gk+vQ==
From:   SeongJae Park <sj@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] Backport oops_limit to 5.4
Date:   Thu,  2 Feb 2023 18:43:38 +0000
Message-Id: <20230202184338.1332-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Feb 2023 20:42:38 -0800 Eric Biggers <ebiggers@kernel.org> wrote:

> This series backports the patchset
> "exit: Put an upper limit on how often we can oops"
> (https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
> to 5.4, as recommended at
> https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
> This follows the backports to 5.10 and 5.15 which already released.
> 
> This required backporting various prerequisite patches.
> 
> I've tested that oops_limit and warn_limit work correctly on x86_64.

Thanks for your great efforts on this.

Tested-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ
