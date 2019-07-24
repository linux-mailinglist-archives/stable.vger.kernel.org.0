Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C373271
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGXPHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:07:54 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:40649 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfGXPHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 11:07:53 -0400
Received: by mail-pl1-f171.google.com with SMTP id a93so22081586pla.7
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 08:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZoLM8AowjBuoDXcLW7/NNFOEe/9fQ2ptWjq0pAGp7Rk=;
        b=iWoN772tj9rq10Ruk0+3sxXeS06XyCHux5clwxcimagQHDriepkGyYVDvUXz3bDYhz
         mi2JaSD0eJGEZzCpaeFVdJ1JORF9iYY8qDeriwSQTCZL/PqER47QYq8kc70xdQunWgcO
         f+cTsXEqcaLALYIkJF0G3g9fHPZeXMKp+cLZ/fUHfxu18Nul6+cIgsC9RhqaYitFu8Ep
         mrvzOQ9WjhzJjLoRs9N+uXjy1mNFCCuXKAYJ85mpShEDeMqDPs3oa/mQD7Y7AVVkDWM0
         jU9vc492T5hQPRblNXo0Qk3HYr6fYQZ9mqFSnCF5sHPjI6TaMtF2qvHiaodxxAVPco0l
         O/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=ZoLM8AowjBuoDXcLW7/NNFOEe/9fQ2ptWjq0pAGp7Rk=;
        b=XaOBhfbiMTAyx5OQ0hZNFJKkV7BZmizYbqW3JspTcRnE1BiIAh300u+nLPhtZSnLQY
         EUtyyOIb6ITG7XY4cAdsRBwCQm+THS7YJ9KuIxdPgWojEEEepPrA8nRgHXeCoshklpUe
         AoxyyqaAw4R1R+shm7RZB4QzPVlb88vcJsxQLoMEym+p+n9jzdbvrd01iuE0N6inaKES
         C/NDWJeWzX4BeQOLZrmA9hpWEzPTUwFl8oNGmB6gHw+Coiso+MzF39TBoZ3s3erSsKxb
         lGV44aZS/1GFkZ24Kxc9dMZ7wZp3wI7+fHwzXzn1aInBP3eyzV1+bqDysspWxexQkRd9
         FOOA==
X-Gm-Message-State: APjAAAU57lNkMhTIsUlM4RipBTyIVQtwllblyoAWiTmYYSrP49KLjvm9
        xGFZ9ee1fZkm0swz6B1WJTvOVpXs
X-Google-Smtp-Source: APXvYqy2PTdG5Z0Le0fCyx+/tyxX+bGu13EsUbnSJe47NI8nMA0AL1CapPxFGsfPdu9mp+j6TeWvrg==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr80928228plb.143.1563980872916;
        Wed, 24 Jul 2019 08:07:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c130sm45292537pfc.184.2019.07.24.08.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 08:07:51 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: btrfs related build failures in stable queues
Message-ID: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
Date:   Wed, 24 Jul 2019 08:07:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4.9.y to v5.1.y:

fs/btrfs/file.c: In function 'btrfs_punch_hole':
fs/btrfs/file.c:2787:27: error: invalid initializer
    struct timespec64 now = current_time(inode);
                            ^~~~~~~~~~~~
fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'

v4.19.y, v5.1.y:

fs/btrfs/props.c: In function 'prop_compression_validate':
fs/btrfs/props.c:369:6: error: implicit declaration of function 'btrfs_compression_is_valid_type'

My apologies for the noise if this has already been reported/fixed.

Guenter
