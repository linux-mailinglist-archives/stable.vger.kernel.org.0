Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05A9BEB7
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfHXQNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 12:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXQNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 12:13:11 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D455C21670
        for <stable@vger.kernel.org>; Sat, 24 Aug 2019 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566663191;
        bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=; h=From:Date:From;
        b=km2MZlqAIXmnNcY+9QlFLT397MvVZGTZ1AchXs1NDKKOYrjplLB583c3w/0EbYoR2
         DSprpM208cDnj8kjop8PFlTuK/Yu1mvLJlRGPhI99MXjw73gayT7g6cVLm2xuI3nZI
         zAlVGzElCCSDm3NbdXp8KcjsbkVGwnw16wl3Rn/k=
From:   Sasha Levin <sashal@kernel.org>
Date:   Sat, 24 Aug 2019 16:13:10 +0000
Message-Id: <20190824161310.D455C21670@mail.kernel.org>
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

