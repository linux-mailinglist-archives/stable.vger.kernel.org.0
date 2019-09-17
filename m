Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B596EB4537
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 03:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391145AbfIQB1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 21:27:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36746 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391143AbfIQB1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 21:27:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so1126062pfr.3
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 18:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4BjLiF/poEXSSePuuLj32cailTHZMkM0kzBCPaqRtjs=;
        b=MDAuOjWAw22VVhmCHN+VHAQlgddrmDdUxMvmlvc2WJxpSbNZ+1dBNUtpYkvSqKP77m
         i/2F9M2v1UtPcvXzb/pFT3sdr/80pQZ1I/jS8xN8DKDOdQKNgHSao0oC2NJpl+uk2Fxc
         0xkzKQ9x9/7uh3O570eGNn7HsYGmHiTaBeGS24mez122oiL0lUnhFwP+G6vuoqOtaWMm
         j6XJMf8ZdE9HYWcumEIFQaRkfkeZ0NxiWWhA0Hxf19giRzLVC9A6hBOASx0vO6DBmnU2
         0rMjsc3ZJZNUVK+vPA+QhnwyxT8tUjLMRwCSRNM/zQSztKnNbyZrgOMJHV+BW7mC6I9g
         SGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=4BjLiF/poEXSSePuuLj32cailTHZMkM0kzBCPaqRtjs=;
        b=ZUG7sB2X7uTvk7aOjsty3dtNO5X97VqV61eqnuckCP8ucwN3A07CQ7gqg2yOjEopp/
         6syYBQ/8JuIBBxp+KJahAae7rUd4YmT/YkONmPZfJ8+uSNkrWkWSQoEe0QuLbcwXwJpg
         AOueD/0SGABDtL413lLHUtkshzCZBx1cWT6HPN81wNPgjrxnB+QymZOjTPn18rxwQGfd
         KvqmqBDzmhuw6uIOipI+4W4fIvQc8Vr27Lf7XfsJom/8ZLTQTj+bcw8ESqCNUSkRu9R3
         hcHSIcsR9NcvM4UqQdTucmKndpIio1jD4klNqiSrUA4i87jQTDoo7/pfXEOriOSrtVlr
         885Q==
X-Gm-Message-State: APjAAAXVQRXp94I4KYvBYk4TM6HCApMsgXbl+i/3sDMyY1F464zHtd83
        nzhUCRRa3l7OTbkYjx9O8lA=
X-Google-Smtp-Source: APXvYqwpt+hEA6122ZOtI5aTFdkXo1nfYUk8gIrhq0vBfiapwR85yRIASrE1h/OSby4UjHUUNPdGRA==
X-Received: by 2002:a17:90a:d792:: with SMTP id z18mr2321231pju.60.1568683625867;
        Mon, 16 Sep 2019 18:27:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z23sm459091pje.2.2019.09.16.18.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 18:27:04 -0700 (PDT)
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Paul Burton <paul.burton@mips.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: mips patches for v4.4.y, v4.9.y, and v4.14.y
Message-ID: <d1030b70-e919-a082-837c-8ac4bb5aaa96@roeck-us.net>
Date:   Mon, 16 Sep 2019 18:27:03 -0700
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

Hi Greg,

please apply the following patches to v4.4.y, v4.9.y, and v4.14.y.

351fdddd3662 ("MIPS: VDSO: Prevent use of smp_processor_id()")
0648e50e548d ("MIPS: VDSO: Use same -m%-float cflag as the kernel proper")

The second patch fixes the build error reported for decstation_defconfig and others
by kernelci, and the first patch is needed to avoid a merge conflict (and it doesn't
hurt to have it in the branch).

Thanks,
Guenter
