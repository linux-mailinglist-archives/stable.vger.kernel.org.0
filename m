Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5D161B97
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgBQT1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:27:40 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:33907 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgBQT1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:27:40 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 14:27:39 EST
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id EBD183E2; Mon, 17 Feb 2020 20:21:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1581967315;
        bh=BMR6wzDwzdgzB/ai33Xe6+LbYfteqqF/3tJ+dCxpV0w=;
        h=Date:From:To:Cc:Subject:From;
        b=eeJDuRTZsGIp3UjBTt4TKSwd2lj/DIuQ7KpeW+4POgx+dISA4W111wPnPIpu76FQP
         2nT/vfugC2/K5TqBwo3MmBBfaQ1KIV0QooZj7e67/rVghWBj9n+k5xD7jZyFqMAeqx
         04OIezq/VCePCx9qHlKxPcBPFJrCTVsk4ja9BsC+LNv/cRBJ/r7mYRa87QlYi2taO0
         YsxBimin6eObg9yOE3xmiXJ7yLqViGEsxeH0SDK0stlpOqT3WAwO7OBGJ7mXIyFO0A
         JAJUM/5d+z8Q+dtVDWo9miQaUNmLR6iFhslf0toLS9QWXo3qLSrwW4sB7ooYKXqj2d
         pWEG6FnZLW5Ig==
Date:   Mon, 17 Feb 2020 20:21:55 +0100
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     stable@vger.kernel.org
Cc:     Gang He <GHe@suse.com>
Subject: ocfs2 fix for 5.4 LTS
Message-ID: <20200217192155.GE18366@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please include the following patch in the 5.4 LTS kernel:

commit b73eba2a867e10b9b4477738677341f3307c07bb
Author: Gang He <GHe@suse.com>
Date:   Sat Jan 4 13:00:22 2020 -0800

    ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less

because ocfs2 module crashes the system starting with commit
v5.2-5650-ge581595ea29c up to the fix in v5.5-rc4-152-gb73eba2a867e.

-- 
Valentin
