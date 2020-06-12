Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871C51F7B7D
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgFLQPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 12:15:50 -0400
Received: from mout.web.de ([217.72.192.78]:41379 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgFLQPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 12:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591978514;
        bh=6XzuCWrpYRv8gmQHvzSs6nimuUvMEMbq3EETOESHhzM=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=bUjwZJx31/Tz/XXl6ZJ+f2FeR/m1csYA+NXqfrhnjVPUUweIHifwvgHr+sVjSmFVc
         KTxgDErccAZgIHW6vVyLyytyvqF6tBhQklb/Vaye5SYn8aor6z62m1VQgL4lLvMcin
         B/pC2VQvQa8QMoZBx9WF6lulPTinYc51fe0ihGSI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.95.40]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MActe-1jd8VW2Omu-00B8aq; Fri, 12
 Jun 2020 18:15:14 +0200
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for value
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6de85422-bdf6-e56c-1042-871b7e8a9a01@web.de>
Date:   Fri, 12 Jun 2020 18:15:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:/qtaIVSu29XGNmVLiJI+e3HOP3EUnmLsEpiGk679YdhBSDg54jU
 DXTlUXhyjQCEFGV6rxrr3KfOPM3TfX5i8d3p2HdIc4hTQguRic1VHRHo+wkS6oT6vxWJWvI
 bA4vaxZ3ddei1ObZn6tnHxe7X7tr+OaGgtOd18ULPnuM9HcS2RzKdq2TkjEOy2mU9Fkn3dK
 0TF2A2R9Sa1NSBNweIc6A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ir8+9ad+2sk=:/9l2LBX+gZZY18Hhm99tB7
 UDutbhF+E8gJM7S0SFzxAiio0zCiQDwI6etecFd6C0+l85oq6nhvZfh46czBI41BzpZ0ArOZh
 R+T1m2RRbU0HRMzhTcP4qO0vtE30JbwZtAEva75ah6LWS/Xq6adJQaJcgCD1ZATbI5uEZmJgr
 xjpf/kSrurn+cuc3YNdctrIO4qe4+NqwKP1gWxXhHYesDA5cVmHfgPObmAXEYy9YYf6msZvss
 eFaPsg4l79SsWGIXhGOmBZOifXp51/Xybp9D98UDCkoJ39jn8JPBpV8HOfPr+LA2my/FiQLNU
 +ns7+k1RfDvYcWiHlOxq1uDJXHjdaYwWzmI3fCGc/dvFUU7SOthVyNmzGRkgq2hu/1KqNn/Z/
 K+vXeEt7OJynZB+HxnwtYEKD47NjlD6jMIhUrPGKi3rWRnMH9v6C+e1+SnNMA+OFrvsQ2qSov
 NmnQnlkPZP58hxuZ+hxPEI6K+KTU3zUzmeXkaZ20aklhLoRpnEcrXVzp+JZT0EtMW6x4rOrrK
 Ml5ZEzw8px/DzrT8Vb39BFj8wUTxN85CHq9xwQPjTWqb6EiZEvDAGvOMGQ173I8Q22PzcBOV0
 SXecVsUNltSaABj0SnLoYImVpHlhdUEK+uThBCLCdxfm8wU8Cdhn8ZtZnHUO8fVWZhtTUe1+y
 GAcriXoqQWGB9A5WDH73qmysc5UI1K5XQfu3Ej1ZGbyciKitty+ZsXspLSxOR7Xozjl2ISbUq
 yWbOHjZ7xAn9ADh7l9uerXZ9VR+RMOk6NXIPabhHzM7Ndo3PRAUurBca8D8I10Bbb5Sv83bg6
 mWlA7jlN36SfuV+MRk5Tx8e+3Xe159l1yqT2rMO8IKDZaSl51DKWyHQKiLZmsGAXdgmGKI/AP
 1pbMm7GLIs7z6Xp29igIX/44e0588py4MSEUx1iEM3IdpyXXPfWcNpKD5+lf0qQ84ynfK1ofU
 gtOmbDnG2UikfbtYUjcY3FsQ4p4XsB8lGW9NPWK5+8DV+sEg5iO/ArhE0arFoyT+Iwk3l8Tn5
 Buy8gpSraezlHYMxK6wiHhMnuPQbj+c8jifhTfjRa2AkSC6pEe1nD7EoYc/vqhpA7OHJe4SuA
 q6IY7F7BZ6P27ye+uSjdbDIZM2kYa7dr7U8i3JS+f7M5Sd8FjO/MtmyHJsPY/R+6PbJGAHd5m
 lbZDYIAbD1wNY8Mg/ySOdBt7DpvVfYvmn1geUPfiedRNIgTES9D9va+eSJ7CpEwbyu3/wFeuu
 g3SSQRNudugXqUPPJ
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Fix /proc/bootconfig to show the correctly choose the
> double or single quotes according to the value.

I suggest to improve this wording a bit.

Regards,
Markus
