Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798484F04E6
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358122AbiDBQcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358118AbiDBQcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 12:32:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6FC6556;
        Sat,  2 Apr 2022 09:30:48 -0700 (PDT)
Received: from integral2.. (unknown [182.2.36.61])
        by gnuweeb.org (Postfix) with ESMTPSA id 79AA37E36C;
        Sat,  2 Apr 2022 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648917047;
        bh=wiF1VbmTmLEiqvXK4Vx8+vWb7XkA3M1V80Ka5xhaEQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=PtbQBaOmsD7TPu+tSK6umCGW2L124av1ZoCUX4bV9PXjax1EUnM+//DzYLKxwMNJM
         QfOmB0H1a69JczAj+C4KoiZuEFVlnxMy+nN0hym6UJSy8uVlJYexfU3y6lNSYRYZ1l
         3cZSa6rPpMUKsKM7Nc3NNocNaYWOpybqpZRM1aDXtEt6l8lh+hWxNF+brFeozYZIBw
         jJpME2s+r1y6aZDmFBv3VOpdf/illmU4jSGLgypuyYH5SOPSePGcKwENlVSOGBj5dN
         lNSsZx82W9NXLMQnb5KZ76sZ3FB6f0GPZgXv7hQqwoJEx8SkrL3xMHfXERyjalNy+R
         OniJkQBx9yQ2A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org
Subject: [PATCH for-stable] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Date:   Sat,  2 Apr 2022 23:30:26 +0700
Message-Id: <20220402163026.11299-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello Greg,

commit b7fb0ae09009d076964afe4c1a2bde1ee2bd88a9 upstream.

Please take these two backport patches:
1. For Linux 5.4 LTS.
2. For Linux 5.10 LTS.

Both will be sent as a reply to this email.

Thank you!

=====

5.4 failed report:
https://lore.kernel.org/stable/164889915082249@kroah.com/


5.10 failed report:
https://lore.kernel.org/stable/164889914960214@kroah.com/

-- 
Ammar Faizi

