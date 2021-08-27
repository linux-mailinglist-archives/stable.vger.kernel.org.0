Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4B3F96BE
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 11:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244497AbhH0JSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 05:18:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36364 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhH0JSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 05:18:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 588FC2235F
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630055869;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=7Ux3A5uXytWJNcHtoHckNiWnyStiXjEQxZIjJFk/KyI=;
        b=pgCS8FVsuvlZELesU/hjnIt0ARTk44J0i+8Z0Nd/7zlFradDDxjQNPHuevUO9Lfhmr7szb
        qbSUhB1JvZk2wdkSWCYwGDqcHr3O7BAozck5t3Y1OmszdaWRwIzQjJyol5GU8zy5HdhwY8
        O9sBbwUOGzB14CRbiNPJhYNGrSu8am8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630055869;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=7Ux3A5uXytWJNcHtoHckNiWnyStiXjEQxZIjJFk/KyI=;
        b=+nyQQ19qm7xm4Kp02Ac9/hF4oAH4u516Pz+mBO+QpTnKFTK8+IDDFTzzZPjneZJ3pzhpHp
        vjrH5hwd7RRh6yAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 51705A3B93;
        Fri, 27 Aug 2021 09:17:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C3C4CDA7F3; Fri, 27 Aug 2021 11:15:00 +0200 (CEST)
Date:   Fri, 27 Aug 2021 11:15:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Please add beadb3347de2 to 5.4 and 5.10
Message-ID: <20210827091500.GT3379@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add commit

beadb3347de27890  btrfs: fix NULL pointer dereference when deleting device by invalid id

to stable trees 5.4 and 5.10 (applies cleanly on both).

Thanks.
