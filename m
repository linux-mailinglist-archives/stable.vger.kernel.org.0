Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675EA381E88
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 13:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEPLmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 07:42:38 -0400
Received: from mail.charleswright.co ([3.220.224.30]:40346 "EHLO
        mail.charleswright.co" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhEPLmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 07:42:37 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2021 07:42:37 EDT
Received: from [192.168.1.2] (ool-44c12c50.dyn.optonline.net [68.193.44.80])
        by mail.charleswright.co (Postfix) with ESMTPSA id A195E2038A;
        Sun, 16 May 2021 07:34:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=charleswright.co;
        s=default; t=1621164874;
        bh=nbRD9o9Y59Ezg4XtPK8gTy9EUk2EIMhmfLFfcaEzpyw=;
        h=To:Cc:From:Subject:Date:From;
        b=ISUA18xXAM19nQeOVHcR1FyU/5eq+f/tu7OWQnYf9C8E9OazCe6vVYTT6t6LxcjC3
         N4QhvRphrnSGiZWxr5OLl6tJx/8I9Vd6dHQVaUiMHHeYmFYJESUt8nvx9Qp2Cs3eHc
         8STzZaIf7Yo5Pwbr4beHBQDlhnTqfAPt58EXc9iB0SgDATKSgrsYsCkMxbK3Tkf/9r
         bhdiacjOttBG46LmaRgh79Rwa1j5wMveVw8e8mhxZiSJpuzpjLA/ABVgsTMPSWPEM7
         NmGYUyUyDRn+L1WqsLXPxGxqshz2iSan4g0sMtnqodv1C/sYbDrzzRkoSqe8ctKawi
         79YF+8VW/Id6w==
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
From:   Charles Wright <charles@charleswright.co>
Subject: 5.10.37 won't boot on my system, but 5.10.36 with same config does
Message-ID: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
Date:   Sun, 16 May 2021 07:34:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I see a couple of other posts with same issue.

https://www.reddit.com/r/voidlinux/comments/nchtph/kernel_51037_1_boot_problem/

https://forums.gentoo.org/viewtopic-p-8610756.html


